# Host Summarization Models Using Geniusrise

- [Host Summarization Models Using Geniusrise](#host-summarization-models-using-geniusrise)
    - [Setup and Configuration](#setup-and-configuration)
    - [Configuration Parameters Explained](#configuration-parameters-explained)
    - [Interacting with the Summarization API](#interacting-with-the-summarization-api)
        - [Summarizing Text](#summarizing-text)
        - [Advanced Summarization Features](#advanced-summarization-features)
    - [Use Cases \& Variations](#use-cases--variations)
        - [Different Summarization Models](#different-summarization-models)
        - [Customizing Summarization Parameters](#customizing-summarization-parameters)
    - [Fun](#fun)
        - [Book summarization](#book-summarization)
        - [Python Code Explainer](#python-code-explainer)
        - [Domain-wise or Content-wise Summarization](#domain-wise-or-content-wise-summarization)
            - [Medical text](#medical-text)
            - [Legal text](#legal-text)
            - [Conversational text](#conversational-text)
    - [Play around](#play-around)


This guide will walk you through setting up, configuring, and interacting with a summarization API using Geniusrise, highlighting various use cases and how to adapt the configuration for different models.

## Setup and Configuration

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

**Installation:**

Begin by installing Geniusrise and its text module:

```bash
pip install geniusrise
pip install geniusrise-text
```

**Configuration (`genius.yml`):**

Create a `genius.yml` to define your summarization service:

```yaml
version: "1"

bolts:
    my_bolt:
        name: SummarizationAPI
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
            model_name: facebook/bart-large-cnn
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

Run your API server with:

```bash
genius rise
```

## Configuration Parameters Explained

- **model_name**: Specifies the pre-trained model, such as `facebook/bart-large-cnn` for summarization.
- **use_cuda**: Utilizes GPU acceleration for faster processing.
- **precision**: Controls computational precision, affecting performance.
- **endpoint & port**: Network address and port for API access.
- **username & password**: Basic authentication for API security.

## Interacting with the Summarization API

### Summarizing Text

You can summarize text by making HTTP requests to your API.

**Example with `curl`**:

```bash
/usr/bin/curl -X POST localhost:3000/api/v1/summarize \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "text": "Theres something magical about Recurrent Neural Networks (RNNs). I still remember when I trained my first recurrent network for Image Captioning. Within a few dozen minutes of training my first baby model (with rather arbitrarily-chosen hyperparameters) started to generate very nice looking descriptions of images that were on the edge of making sense. Sometimes the ratio of how simple your model is to the quality of the results you get out of it blows past your expectations, and this was one of those times. What made this result so shocking at the time was that the common wisdom was that RNNs were supposed to be difficult to train (with more experience Ive in fact reached the opposite conclusion). Fast forward about a year: Im training RNNs all the time and Ive witnessed their power and robustness many times, and yet their magical outputs still find ways of amusing me.",
        "decoding_strategy": "generate",
        "bos_token_id": 0,
        "decoder_start_token_id": 2,
        "early_stopping": true,
        "eos_token_id": 2,
        "forced_bos_token_id": 0,
        "forced_eos_token_id": 2,
        "length_penalty": 2.0,
        "max_length": 142,
        "min_length": 56,
        "no_repeat_ngram_size": 3,
        "num_beams": 4,
        "pad_token_id": 1,
        "do_sample": false
    }' | jq
```

**Example with `python-requests`**:

```python
import requests

data = {
    "text": "Theres something magical about Recurrent Neural Networks (RNNs). I still remember when I trained my first recurrent network for Image Captioning. Within a few dozen minutes of training my first baby model (with rather arbitrarily-chosen hyperparameters) started to generate very nice looking descriptions of images that were on the edge of making sense. Sometimes the ratio of how simple your model is to the quality of the results you get out of it blows past your expectations, and this was one of those times. What made this result so shocking at the time was that the common wisdom was that RNNs were supposed to be difficult to train (with more experience Ive in fact reached the opposite conclusion). Fast forward about a year: Im training RNNs all the time and Ive witnessed their power and robustness many times, and yet their magical outputs still find ways of amusing me.",
    "decoding_strategy": "generate",
    "bos_token_id": 0,
    "decoder_start_token_id": 2,
    "early_stopping": true,
    "eos_token_id": 2,
    "forced_bos_token_id": 0,
    "forced_eos_token_id": 2,
    "length_penalty": 2.0,
    "max_length": 142,
    "min_length": 56,
    "no_repeat_ngram_size": 3,
    "num_beams": 4,
    "pad_token_id": 1,
    "do_sample": false
}

response = requests.post("http://localhost:3000/api/v1/summarize",
                         json=data,
                         auth=('user', 'password'))
print(response.json())
```

### Advanced Summarization Features

For use cases requiring specific summarization strategies or adjustments (e.g., length penalty, no repeat ngram size), additional parameters can be included in your request to customize the summarization output.

## Use Cases & Variations

### Different Summarization Models

To cater to various summarization needs, such as domain-specific texts or languages, simply adjust the `model_name` in your `genius.yml`. For example, for summarizing scientific papers, you might choose a model like `allenai/longformer-base-4096`.

### Customizing Summarization Parameters

Adjust summarization parameters such as `max_length`, `min_length`, and `num_beams` to fine-tune the output based on the specific requirements of your application.

## Fun

### Book summarization

Models with very large context sizes trained on the [booksum](https://huggingface.co/datasets/kmfoda/booksum) dataset.
For example [pszemraj/led-base-book-summary](https://huggingface.co/pszemraj/led-base-book-summary), [pszemraj/bigbird-pegasus-large-K-booksum](https://huggingface.co/pszemraj/bigbird-pegasus-large-K-booksum) or the following large model:

```yaml
version: "1"

bolts:
    my_bolt:
        name: SummarizationAPI
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
            model_name: pszemraj/led-large-book-summary
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

```bash
/usr/bin/curl -X POST localhost:3000/api/v1/summarize \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "text": " the big variety of data coming from diverse sources is one of the key properties of the big data phenomenon. It is, therefore, beneficial to understand how data is generated in various environments and scenarios, before looking at what should be done with this data and how to design the best possible architecture to accomplish this The evolution of IT architectures, described in Chapter 2, means that the data is no longer processed by a few big monolith systems, but rather by a group of services In parallel to the processing layer, the underlying data storage has also changed and became more distributed This, in turn, required a significant paradigm shift as the traditional approach to transactions (ACID) could no longer be supported. On top of this, cloud computing is becoming a major approach with the benefits of reducing costs and providing on-demand scalability but at the same time introducing concerns about privacy, data ownership, etc In the meantime the Internet continues its exponential growth: Every day both structured and unstructured data is published and available for processing: To achieve competitive advantage companies have to relate their corporate resources to external services, e.g. financial markets, weather forecasts, social media, etc While several of the sites provide some sort of API to access the data in a more orderly fashion; countless sources require advanced web mining and Natural Language Processing (NLP) processing techniques: Advances in science push researchers to construct new instruments for observing the universe O conducting experiments to understand even better the laws of physics and other domains. Every year humans have at their disposal new telescopes, space probes, particle accelerators, etc These instruments generate huge streams of data, which need to be stored and analyzed. The constant drive for efficiency in the industry motivates the introduction of new automation techniques and process optimization: This could not be done without analyzing the precise data that describe these processes. As more and more human tasks are automated, machines provide rich data sets, which can be analyzed in real-time to drive efficiency to new levels. Finally, it is now evident that the growth of the Internet of Things is becoming a major source of data. More and more of the devices are equipped with significant computational power and can generate a continuous data stream from their sensors. In the subsequent sections of this chapter, we will look at the domains described above to see what they generate in terms of data sets. We will compare the volumes but will also look at what is characteristic and important from their respective points of view. 3.1 The Internet is undoubtedly the largest database ever created by humans. While several well described; cleaned, and structured data sets have been made available through this medium, most of the resources are of an ambiguous, unstructured, incomplete or even erroneous nature. Still, several examples in the areas such as opinion mining, social media analysis, e-governance, etc, clearly show the potential lying in these resources. Those who can successfully mine and interpret the Internet data can gain unique insight and competitive advantage in their business An important area of data analytics on the edge of corporate IT and the Internet is Web Analytics.",
        "decoding_strategy": "generate",
        "bos_token_id": 0,
        "decoder_start_token_id": 2,
        "early_stopping": true,
        "eos_token_id": 2,
        "forced_bos_token_id": 0,
        "forced_eos_token_id": 2,
        "length_penalty": 2.0,
        "max_length": 142,
        "min_length": 56,
        "no_repeat_ngram_size": 3,
        "num_beams": 4,
        "pad_token_id": 1,
        "do_sample": false
    }' | jq
```

### Python Code Explainer

Summarization is a text-to-text task and can be used to transform the input text into another form, in this case this model transforms python code into simple english explanations:

```yaml
version: "1"

bolts:
    my_bolt:
        name: SummarizationAPI
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
            model_name: sagard21/python-code-explainer
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

```bash
/usr/bin/curl -X POST localhost:3000/api/v1/summarize \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "text": "    def create_parser(self, parser):\n        """\n        Create and return the command-line parser for managing spouts and bolts.\n        """\n        # fmt: off\n        subparsers = parser.add_subparsers(dest="deploy")\n        up_parser = subparsers.add_parser("up", help="Deploy according to the genius.yml file.", formatter_class=RichHelpFormatter)\n        up_parser.add_argument("--spout", type=str, help="Name of the specific spout to run.")\n        up_parser.add_argument("--bolt", type=str, help="Name of the specific bolt to run.")\n        up_parser.add_argument("--file", default="genius.yml", type=str, help="Path of the genius.yml file, default to .")\n\n        parser.add_argument("--spout", type=str, help="Name of the specific spout to run.")\n        parser.add_argument("--bolt", type=str, help="Name of the specific bolt to run.")\n        parser.add_argument("--file", default="genius.yml", type=str, help="Path of the genius.yml file, default to .")\n        # fmt: on\n\n        return parser",
        "decoding_strategy": "generate",
        "bos_token_id": 0,
        "decoder_start_token_id": 2,
        "early_stopping": true,
        "eos_token_id": 2,
        "forced_bos_token_id": 0,
        "forced_eos_token_id": 2,
        "length_penalty": 2.0,
        "max_length": 142,
        "min_length": 56,
        "no_repeat_ngram_size": 3,
        "num_beams": 4,
        "pad_token_id": 1,
        "do_sample": false
    }' | jq
```

### Domain-wise or Content-wise Summarization

Models can be specialized in performing better at specialized fine-tuning tasks along various verticals - like domain knowledge or content.

Here are a few examples:

#### Medical text

```yaml
version: "1"

bolts:
    my_bolt:
        name: SummarizationAPI
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
            model_name: Falconsai/medical_summarization
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

#### Legal text

```yaml
version: "1"

bolts:
    my_bolt:
        name: SummarizationAPI
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
            model_name: EasyTerms/legalSummerizerET
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

#### Conversational text

```yaml
version: "1"

bolts:
    my_bolt:
        name: SummarizationAPI
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
            model_name: kabita-choudhary/finetuned-bart-for-conversation-summary
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

## Play around

At 1551 open source models on the [hub](https://huggingface.co/models?pipeline_tag=summarization&sort=downloads), there is enough to learn and play.
