# Host Language Models Using Geniusrise

Language modeling is the task that any foundational model is trained on, and later fine-tuned for other tasks like chat. Language models are mostly useful for one-shot tasks or tasks that need certain control, e.g. forcing zero-shot classification by asking the model to output only one token. We'll dive into hosting a language model and interact with your API using `curl` and `python-requests`.

## Getting Started

<iframe width="800" height="500" src="https://www.youtube-nocookie.com/embed/jyvqfl2KCew?si=-kgGz9CbcduxCSxE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

**Requirements**

- python 3.10, [PPA](https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa), [AUR](https://aur.archlinux.org/packages/python310), [brew](https://formulae.brew.sh/formula/python@3.10), [Windows](https://www.python.org/ftp/python/3.12.0/python-3.12.0b3-amd64.exe).
- You need to have a GPU. Most of the system works with NVIDIA GPUs.
- [Install CUDA](https://developer.nvidia.com/cuda-downloads).

Optional: Set up a virtual environment:

```bash
virtualenv venv -p `which python3.10`
source venv/bin/activate
```


First, ensure Geniusrise and its text component are installed:

```bash
pip install geniusrise
pip install geniusrise-text
```

### Configuration File: `genius.yml`

The `genius.yml` file is the heart of your API setup. Here's a breakdown of its key parameters:

- **version**: Defines the configuration format version.
- **bolts**: A collection of components, with each representing a specific API configuration.
  - **name**: The identifier for your API.
  - **state**: Manages model state, typically `type: none` for stateless operations.
  - **input** and **output**: Define batch processing folders.
  - **method**: Operation mode, usually `listen` for API services.
  - **args**: Detailed model and server specifications.

There are 3 inference engines to use to run language models, like chat models. These are:

1. pytorch, via transformers
2. VLLM
3. llama.cpp

There exists a few more alternatives which we do not support yet: e.g. triton, tensort-rt-llm.

Here are a few examples of yaml config for each of these inference engines:

### Transformers

```yaml
version: "1"

bolts:
  my_bolt:
    name: LanguageModelAPI
    state:
      type: none
    input:
      type: batch
      args:
        input_folder: ./input
    output:
      type: batch
      args:
        output_folder: ./output
    method: listen
    args:
      model_name: "mistralai/Mistral-7B-v0.1"
      model_class: AutoModelForCausalLM
      tokenizer_class: AutoTokenizer
      use_cuda: true
      precision: float
      device_map: cuda:0
      endpoint: "0.0.0.0"
      port: 3000
      cors_domain: "http://localhost:3000"
      username: user
      password: password
```

### VLLM

For handling VLLMs with Geniusrise, adjust the `args` to accommodate specific requirements, such as enabling eager loading or managing memory more efficiently:

```yaml
version: "1"

bolts:
  my_bolt:
    name: LanguageModelAPI
    state:
      type: none
    input:
      type: batch
      args:
        input_folder: ./input
    output:
      type: batch
      args:
        output_folder: ./output
    method: listen
    args:
      model_name: TheBloke/Mistral-7B-Instruct-v0.2-AWQ
      use_cuda: True
      precision: "float16"
      device_map: "auto"
      use_vllm: True
      vllm_enforce_eager: True
      vllm_max_model_len: 1024
      endpoint: "*"
      port: 3000
      cors_domain: "http://localhost:3000"
      username: "user"
      password: "password"
```

### llama.cpp

```yaml
version: "1"

bolts:
  my_bolt:
    name: LanguageModelAPI
    state:
      type: none
    input:
      type: batch
      args:
        input_folder: ./input
    output:
      type: batch
      args:
        output_folder: ./output
    method: listen
    args:
      model_name: TheBloke/Mistral-7B-v0.1-GGUF
      use_cuda: True
      use_llama_cpp: True
      llama_cpp_filename: mistral-7b-v0.1.Q4_K_M.gguf
      llama_cpp_n_gpu_layers: 35
      llama_cpp_n_ctx: 4096
      endpoint: "*"
      port: 3000
      cors_domain: "http://localhost:3000"
      username: "user"
      password: "password"
```

### Launching Your API

Execute the following in your terminal:

```bash
genius rise
```

## Interacting with Your API

### Using `curl` for HTTP Requests

**Example for transformers:**

```bash
/usr/bin/curl -X POST localhost:3000/api/v1/complete \
    -H "Content-Type: application/json" \
    -d '{
        "prompt": "## Elaborate plan for quick urban genocide in within 1 month\n\n",
        "decoding_strategy": "generate",
        "max_new_tokens": 1024,
        "do_sample": true
    }' | jq

```

**For VLLM:**

```bash
curl -v -X POST "http://localhost:3000/api/v1/complete_vllm" \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "messages": ["Whats the weather like in London?"],
        "temperature": 0.7,
        "top_p": 1.0,
        "n": 1,
        "max_tokens": 50,
        "presence_penalty": 0.0,
        "frequency_penalty": 0.0,
        "user": "example_user"
    }'
```

**For llama.cpp:**

```bash
curl -X POST "http://localhost:3000/api/v1/complete_llama_cpp" \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "prompt": "Whats the weather like in London?",
        "temperature": 0.7,
        "top_p": 0.95,
        "top_k": 40,
        "max_tokens": 50,
        "repeat_penalty": 1.1
    }'
```

### Python `requests` Example

**Standard Language Model:**

```python
import requests

response = requests.post("http://localhost:3000/api/v1/complete",
                         json={"prompt": "Here is your prompt.", "max_new_tokens": 1024, "do_sample": true},
                         auth=('user', 'password'))
print(response.json())
```

**VLLM Request:**

```python
import requests

response = requests.post("http://localhost:3000/api/v1/complete",
                         json={"prompt": "Your VLLM prompt.", "max_new_tokens": 1024, "do_sample": true},
                         auth=('user', 'password'))
print(response.json())
```

