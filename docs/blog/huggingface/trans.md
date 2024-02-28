# Host Translation Models Using Geniusrise

This guide will walk you through deploying translation models using Geniusrise, covering the setup, configuration, and interaction with the translation API for various use cases.

## Setup and Configuration

**Requirements**

<iframe width="800" height="500" src="https://www.youtube-nocookie.com/embed/jyvqfl2KCew?si=-kgGz9CbcduxCSxE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

- python 3.10, [PPA](https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa), [AUR](https://aur.archlinux.org/packages/python310), [brew](https://formulae.brew.sh/formula/python@3.10), [Windows](https://www.python.org/ftp/python/3.12.0/python-3.12.0b3-amd64.exe).
- You need to have a GPU. Most of the system works with NVIDIA GPUs.
- [Install CUDA](https://developer.nvidia.com/cuda-downloads).

Optional: Set up a virtual environment:

```bash
virtualenv venv -p `which python3.10`
source venv/bin/activate
```

**Installation:**

Begin by installing Geniusrise and the necessary text processing extensions:

```bash
pip install geniusrise
pip install geniusrise-text
```

**Configuration (`genius.yml`):**

Next, define your translation service in a `genius.yml` file:

```yml
version: "1"

bolts:
    my_bolt:
        name: TranslationAPI
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
            model_name: facebook/mbart-large-50-many-to-many-mmt
            model_class: AutoModelForSeq2SeqLM
            tokenizer_class: AutoTokenizer
            use_cuda: true
            precision: float
            device_map: cuda:0
            endpoint: "0.0.0.0"
            port: 3000
            cors_domain: http://localhost:3000
            username: user
            password: password
```

To launch your API, execute:

```bash
genius rise
```

<iframe width="800" height="500" src="https://www.youtube-nocookie.com/embed/5yPT79m7r7o?si=HgFomteKYR5ruh6t" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Configuration Parameters Explained

- **model_name**: Specifies the model to use, such as `facebook/mbart-large-50-many-to-many-mmt` for multilingual translation.
- **model_class & tokenizer_class**: Defines the classes for the model and tokenizer, crucial for the translation process.
- **use_cuda**: Indicates whether to use GPU acceleration for faster processing.
- **precision**: The computational precision (e.g., `float`) affects performance and resource usage.
- **endpoint & port**: The network address where the API is accessible.
- **username & password**: Security credentials for accessing the API.

## Interacting with the Translation API

### Translating Text

Translate text from one language to another using a simple HTTP request.

**Example using `curl`**:

```bash
curl -X POST http://localhost:3000/api/v1/translate \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "text": "संयुक्त राष्ट्र के प्रमुख का कहना है कि सीरिया में कोई सैन्य समाधान नहीं है",
        "source_lang": "hi_IN",
        "target_lang": "en_XX",
        "decoding_strategy": "generate",
        "decoder_start_token_id": 2,
        "early_stopping": true,
        "eos_token_id": 2,
        "forced_eos_token_id": 2,
        "max_length": 200,
        "num_beams": 5,
        "pad_token_id": 1
    }' | jq
```

**Example using `python-requests`**:

```python
import requests

data = {
    "text": "संयुक्त राष्ट्र के प्रमुख का कहना है कि सीरिया में कोई सैन्य समाधान नहीं है",
    "source_lang": "hi_IN",
    "target_lang": "en_XX",
    "decoding_strategy": "generate",
    "decoder_start_token_id": 2,
    "early_stopping": true,
    "eos_token_id": 2,
    "forced_eos_token_id": 2,
    "max_length": 200,
    "num_beams": 5,
    "pad_token_id": 1
}

response = requests.post("http://localhost:3000/api/v1/translate",
                         json=data,
                         auth=('user', 'password'))
print(response.json())
```

### Advanced Translation Features

For use cases requiring specific translation strategies or parameters (e.g., beam search, number of beams), you can pass additional parameters in your request to customize the translation process.

## Use Cases & Variations

### Different Language Pairs

Adjust the `source_lang` and `target_lang` parameters to cater to various language pairs, enabling translation between numerous languages supported by the chosen model.

### Customizing Translation Parameters

For advanced translation needs, such as controlling the length of the output or employing beam search, modify the `additional_params` in your requests:

```json
{
  "text": "Your text here",
  "source_lang": "en_XX",
  "target_lang": "es_XX",
  "num_beams": 4
}
```

## Fun

There are two families of models from facebook that can perform any to any language translation among a large number of languages.

- [facebook/mbart-large-50-many-to-many-mmt](https://huggingface.co/facebook/mbart-large-50-many-to-many-mmt): 50 languages
- [facebook/nllb-200-distilled-600M](https://huggingface.co/facebook/nllb-200-distilled-600M): 200 languages

Both the MBART and the NLLB families have several members, with [facebook/nllb-moe-54b](https://huggingface.co/facebook/nllb-moe-54b) 54billion parameter mixture of experts being the largest and most capable one.

See [here](https://github.com/facebookresearch/flores/blob/main/flores200/README.md#languages-in-flores-200) for the language codes for the FLORES-200 dataset.

```yml
version: "1"

bolts:
    my_bolt:
        name: TranslationAPI
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
            model_name: facebook/nllb-200-3.3B
            model_class: AutoModelForSeq2SeqLM
            tokenizer_class: AutoTokenizer
            use_cuda: true
            precision: float
            device_map: cuda:0
            endpoint: "0.0.0.0"
            port: 3000
            cors_domain: http://localhost:3000
            username: user
            password: password
```

We can try translating from hindi to tatar:

```bash
curl -X POST http://localhost:3000/api/v1/translate \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "text": "संयुक्त राष्ट्र के प्रमुख का कहना है कि सीरिया में कोई सैन्य समाधान नहीं है",
        "target_lang": "tat_Cyrl",
        "decoding_strategy": "generate",
        "bos_token_id": 0,
        "decoder_start_token_id": 2,
        "eos_token_id": 2,
        "max_length": 200,
        "pad_token_id": 1
    }'
```

Now how do we even verify whether this is correct? Lets reverse translate followed by sentence similarity from NLI. We need to launch 2 containers - one for translation and another for NLI:

```yaml
version: "1"

bolts:
    my_translation_bolt:
        name: TranslationAPI
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
            model_name: facebook/nllb-200-3.3B
            model_class: AutoModelForSeq2SeqLM
            tokenizer_class: AutoTokenizer
            use_cuda: true
            precision: float
            device_map: cuda:0
            endpoint: "0.0.0.0"
            port: 3000
            cors_domain: http://localhost:3000
            username: user
            password: password

    my_nli_bolt:
        name: NLIAPI
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
            model_name: facebook/bart-large-mnli
            model_class: AutoModelForSequenceClassification
            tokenizer_class: AutoTokenizer
            use_cuda: true
            precision: float
            device_map: cuda:0
            endpoint: "0.0.0.0"
            port: 3001
            cors_domain: http://localhost:3001
            username: user
            password: password
```

```py
import requests

# First we translate this hindi sentence to tatar
data = {
    "text": "संयुक्त राष्ट्र के प्रमुख का कहना है कि सीरिया में कोई सैन्य समाधान नहीं है",
    "target_lang": "tat_Cyrl",
    "decoding_strategy": "generate",
    "bos_token_id": 0,
    "decoder_start_token_id": 2,
    "eos_token_id": 2,
    "max_length": 200,
    "pad_token_id": 1
}
response = requests.post("http://localhost:3000/api/v1/translate",
                         json=data,
                         auth=('user', 'password'))
translated = response.json()["translated_text"]
# БМО башлыгы Сүриядә хәрби чаралар юк дип белдерә

# Then we translate the tatar back to hindi
rev = data.copy()
rev["text"] = translated
rev["target_lang"] = "hin_Deva"
response = requests.post("http://localhost:3000/api/v1/translate",
                         json=rev,
                         auth=('user', 'password'))
rev_translated = response.json()["translated_text"]

# Finally we look at similarity of the source and reverse-translated hindi sentences
data = {
  "text1": data["text"],
  "text2": rev_translated
}
response = requests.post("http://localhost:3001/api/v1/textual_similarity",
                         json=data,
                         auth=('user', 'password'))

print(response.json())

# {
#     'text1': 'संयुक्त राष्ट्र के प्रमुख का कहना है कि सीरिया में कोई सैन्य समाधान नहीं है',
#     'text2': 'बीएमओ प्रमुख ने कहा कि सीरिया में कोई सैन्य उपाय नहीं हैं',
#     'similarity_score': 0.9829527983379287
# }
```
`0.9829527983379287` looks like a great similarity score, so the translation really works! (or the mistakes are isomorphic) 🥳👍

## Play around

There is not much to really do in translation except mess around with different languagues 🤷‍♂️ Not many models either, facebook is the undisputed leader in translation models.
