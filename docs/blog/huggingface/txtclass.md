# Host Text Classification Models Using Geniusrise

- [Host Text Classification Models Using Geniusrise](#host-text-classification-models-using-geniusrise)
  - [Quick Setup](#quick-setup)
  - [Configuration Breakdown](#configuration-breakdown)
  - [Use Cases \& Variations](#use-cases--variations)
    - [Sentiment Analysis](#sentiment-analysis)
    - [Content Moderation](#content-moderation)
    - [Language Detection](#language-detection)
    - [Making API Requests](#making-api-requests)
      - [Classify Text](#classify-text)
      - [Classification Pipeline](#classification-pipeline)
  - [Fun](#fun)
    - [Political bias detection](#political-bias-detection)
    - [Intent classification](#intent-classification)
    - [Hallucination Evaluation](#hallucination-evaluation)
    - [Irony Detection](#irony-detection)
  - [Play around](#play-around)


This post will guide you through creating inference APIs for different text classification tasks using geniusrise, explaining the `genius.yml` configuration and providing examples of how to interact with your API using `curl` and `python-requests`.

## Quick Setup

<iframe width="800" height="500" src="https://www.youtube-nocookie.com/embed/jyvqfl2KCew?si=-kgGz9CbcduxCSxE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

**Requirements:**

- python 3.10, [PPA](https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa), [AUR](https://aur.archlinux.org/packages/python310), [brew](https://formulae.brew.sh/formula/python@3.10), [Windows](https://www.python.org/ftp/python/3.12.0/python-3.12.0b3-amd64.exe).
- You need to have a GPU. Most of the system works with NVIDIA GPUs.
- [Install CUDA](https://developer.nvidia.com/cuda-downloads).

**Installation:**

Optional: Set up a virtual environment:

```bash
virtualenv venv -p `which python3.10`
source venv/bin/activate
```

Install the packages:

```bash
pip install torch
pip install geniusrise
pip install geniusrise-text
```

**Configuration File (`genius.yml`):**

Create a `genius.yml` with the necessary configuration for your text classification API:

```yaml
version: "1"

bolts:
    my_bolt:
        name: TextClassificationAPI
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
            model_name: tomh/toxigen_roberta
            model_class: AutoModelForSequenceClassification
            tokenizer_class: AutoTokenizer
            use_cuda: true
            precision: float
            device_map: cuda:0
            compile: false
            endpoint: "0.0.0.0"
            port: 3000
            cors_domain: http://localhost:3000
            username: user
            password: password
```

Launch your API with:

```bash
genius rise
```

<iframe width="800" height="500" src="https://www.youtube-nocookie.com/embed/PXIoge6kFPo?si=fiOkIYZgxwwHOi3a" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Configuration Breakdown

- **model_name**: Specify the Hugging Face model ID, e.g., `bert-base-uncased` for sentiment analysis.
- **use_cuda**: Enable GPU acceleration with `true` or `false` for CPU.
- **precision**: Set to `float` for single precision; consider `half` for faster inference on compatible GPUs. Does not work for most small models.
- **device_map**: Assign model parts to specific GPUs, e.g., `cuda:0`.
- **endpoint** & **port**: Define the API access point.
- **username** & **password**: Secure your API with basic authentication.

## Use Cases & Variations

### Sentiment Analysis

For sentiment analysis, swap the `model_name` to a model trained for sentiment, like `distilbert-base-uncased-finetuned-sst-2-english`.

```yaml
args:
  model_name: "distilbert-base-uncased-finetuned-sst-2-english"
```

### Content Moderation

To filter inappropriate content, use a model like `roberta-base-openai-detector`.

```yaml
args:
  model_name: "roberta-base-openai-detector"
```

### Language Detection

For detecting the language of the input text, a model like `xlm-roberta-base` is suitable.

```yaml
args:
  model_name: "xlm-roberta-base"
```

Try out various models from [huggingface](https://huggingface.co/models?pipeline_tag=text-classification&sort=trending).

### Making API Requests

#### Classify Text

**cURL:**

```bash
curl -X POST http://localhost:3000/api/v1/classify \
     -H "Content-Type: application/json" \
     -u "user:password" \
     -d '{"text": "Your text here."}'
```

**Python-Requests:**

```python
import requests

response = requests.post("http://localhost:3000/api/v1/classify",
                         json={"text": "Your text here."},
                         auth=('user', 'password'))
print(response.json())
```

#### Classification Pipeline

**cURL:**

```bash
curl -X POST http://localhost:3000/api/v1/classification_pipeline \
     -H "Content-Type: application/json" \
     -u "user:password" \
     -d '{"text": "Your text here."}'
```

**Python-Requests:**

```python
import requests

response = requests.post("http://localhost:3000/api/v1/classification_pipeline",
                         json={"text": "Your text here."},
                         auth=('user', 'password'))
print(response.json())
```

## Fun

There are quite a few fun models to try out from huggingface!

### Political bias detection

This model tries to classify text according to the political bias they might possess.

```yaml
version: "1"

bolts:
    my_bolt:
        name: TextClassificationAPI
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
            model_name: bucketresearch/politicalBiasBERT
            model_class: AutoModelForSequenceClassification
            tokenizer_class: AutoTokenizer
            use_cuda: true
            precision: float
            device_map: cuda:0
            compile: false
            endpoint: "0.0.0.0"
            port: 3000
            cors_domain: http://localhost:3000
            username: user
            password: password
```

```bash
/usr/bin/curl -X POST localhost:3000/api/v1/classify \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "text": "i think i agree with bjp that hindus need to be respected"
    }' | jq

# {
#   "input": "i think i agree with bjp that hindus need to be respected",
#   "label_scores": {
#     "LEFT": 0.28080788254737854,
#     "CENTER": 0.18140915036201477,
#     "RIGHT": 0.5377829670906067 # <--
#   }
# }
```

```bash
/usr/bin/curl -X POST localhost:3000/api/v1/classify \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "text": "these ghettos are sprawling these days and the people who live there stink"
    }' | jq


# {
#   "input": "these ghettos are sprawling these days and the people who live there stink",
#   "label_scores": {
#     "LEFT": 0.38681042194366455, # <-- NIMBY?
#     "CENTER": 0.20437702536582947,
#     "RIGHT": 0.408812552690506 # <--
#   }
# }
```

Works fairly well empirically for medium-sized sentences and in an american context.

### Intent classification

Text classification can be used to figure out the intent of the user in a chat conversation scenario. For e.g. to determine whether the user has an intent to explore or to buy.

```yaml
version: "1"

bolts:
    my_bolt:
        name: TextClassificationAPI
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
            model_name: Falconsai/intent_classification
            model_class: AutoModelForSequenceClassification
            tokenizer_class: AutoTokenizer
            use_cuda: true
            precision: float
            device_map: cuda:0
            compile: false
            endpoint: "0.0.0.0"
            port: 3000
            cors_domain: http://localhost:3000
            username: user
            password: password
```

```bash
/usr/bin/curl -X POST localhost:3000/api/v1/classify \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "text": "hey i havent got my package yet where is it"
    }' | jq

# {
#   "input": "hey i havent got my package yet where is it",
#   "label_scores": {
#     "cancellation": 6.553709398088303E-12,
#     "ordering": 4.977344745534613E-15,
#     "shipping": 4.109915668426903E-15,
#     "invoicing": 1.3524543897996955E-13,
#     "billing and payment": 2.5260177283215057E-10,
#     "returns and refunds": 1.915349389508547E-12,
#     "complaints and feedback": 1.0671016614826126E-13,
#     "speak to person": 2.6417441435886042E-15,
#     "edit account": 3.1924864227900196E-13,
#     "delete account": 2.704471304022793E-13,
#     "delivery information": 1.0,                 # <--
#     "subscription": 1.2307567616963444E-13,
#     "recover password": 1.387644556552492E-12,
#     "registration problems": 2.686436142984583E-13,
#     "appointment": 3.555285948454723E-13
#   }
# }
```

### Hallucination Evaluation

Figuring out whether your chat / LLM model is hallucinating or not is a text classification task!

```yaml
version: "1"

bolts:
    my_bolt:
        name: TextClassificationAPI
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
            model_name: vectara/hallucination_evaluation_model
            model_class: AutoModelForSequenceClassification
            tokenizer_class: AutoTokenizer
            use_cuda: true
            precision: float
            device_map: cuda:0
            compile: false
            endpoint: "0.0.0.0"
            port: 3000
            cors_domain: http://localhost:3000
            username: user
            password: password
```

```bash
/usr/bin/curl -X POST localhost:3000/api/v1/classify \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "text": "A man walks into a bar and buys a drink [SEP] A bloke swigs alcohol at a pub"
    }' | jq

# {
#   "input": "A man walks into a bar and buys a drink [SEP] A bloke swigs alcohol at a pub",
#   "label_scores": [
#     0.6105160713195801
#   ]
# }
```

### Irony Detection

Yussss NLP has advanced enough for us to be easily be able to detect irony!

```yaml
version: "1"

bolts:
    my_bolt:
        name: TextClassificationAPI
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
            model_name: cardiffnlp/twitter-roberta-base-irony
            model_class: AutoModelForSequenceClassification
            tokenizer_class: AutoTokenizer
            use_cuda: true
            precision: float
            device_map: cuda:0
            compile: false
            endpoint: "0.0.0.0"
            port: 3000
            cors_domain: http://localhost:3000
            username: user
            password: password
```

```bash

/usr/bin/curl -X POST localhost:3000/api/v1/classify \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "text": "What a wonderful day to have a flat tire!"
    }' | jq

# {
#   "input": "What a wonderful day to have a flat tire!",
#   "label_scores": {
#     "non_irony": 0.023495545610785484,
#     "irony": 0.9765045046806335  <---
#   }
# }
```

## Play around

There are 49,863 text classification models as of this article on huggingface. Play around with them, tweak various parameters, learn about various usecases and cool shit that can be built with "mere" text classification!
