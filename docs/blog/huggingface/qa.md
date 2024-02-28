# Host Question Answering Models Using Geniusrise

- [Host Question Answering Models Using Geniusrise](#host-question-answering-models-using-geniusrise)
  - [Types of Question Answering Tasks](#types-of-question-answering-tasks)
    - [Generative](#generative)
    - [Extractive](#extractive)
    - [Why Extractive May be Better](#why-extractive-may-be-better)
  - [Installation and Configuration](#installation-and-configuration)
  - [Understanding `genius.yml`](#understanding-geniusyml)
  - [Use Cases \& Variations](#use-cases--variations)
  - [Making API Requests](#making-api-requests)
    - [Direct Question Answering API](#direct-question-answering-api)
    - [Hugging Face Pipeline API](#hugging-face-pipeline-api)
  - [Fun](#fun)
    - [Long contexts](#long-contexts)
    - [Domain-specific](#domain-specific)
  - [Play around](#play-around)

Deploying question answering (QA) models can significantly enhance the capabilities of applications, providing users with specific, concise answers to their queries. Geniusrise simplifies this process, enabling developers to rapidly set up and deploy QA APIs. This guide will walk you through the steps to create inference APIs for different QA tasks using Geniusrise, focusing on configuring the `genius.yml` file and providing interaction examples via `curl` and `python-requests`.

## Types of Question Answering Tasks

Before diving into the setup and deployment of question answering (QA) models using Geniusrise, it's essential to understand the two main types of QA tasks: generative and extractive. This distinction is crucial for selecting the right model for your application and configuring your `genius.yml` file accordingly.

### Generative

Generative QA models are designed to produce answers by generating text based on the context and the question asked. These models do not restrict their responses to the text's snippets but rather "generate" a new text passage that answers the question. Generative models are powerful for open-ended questions where the answer may not be directly present in the context or requires synthesis of information from multiple parts of the context.

### Extractive

Extractive QA models, on the other hand, identify and extract a specific snippet from the provided text that answers the question. This approach is particularly effective for factual questions where the answer is explicitly stated in the text. Extractive QA is advantageous because it limits the model's responses to the actual content of the input text, reducing the chances of hallucination (producing incorrect or unfounded information) that can occur with generative models.

### Why Extractive May be Better

- **Accuracy**: Extractive QA models provide answers directly sourced from the input text, ensuring that the information is accurate and grounded in the provided context.
- **Reliability**: By constraining the answers to the text snippets, extractive QA minimizes the risk of hallucinations, making it a reliable choice for applications where factual correctness is paramount.
- **Efficiency for RAG**: Extractive QA tasks can be particularly efficient for Retrieval-Augmented Generation (RAG) because they allow for precise information retrieval without the need for generating new text, which can be computationally more demanding.

The models discussed in this guide focus on extractive QA tasks, which are particularly well-suited for direct, fact-based question answering from provided texts.

Extractive QA models are ideal for applications requiring high precision and direct answers from given texts.

## Installation and Configuration

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

**Step 1: Install Geniusrise**

```bash
pip install torch
pip install geniusrise
pip install geniusrise-text
```

**Step 2: Create Your Configuration File (`genius.yml`)**

```yml
version: "1"

bolts:
    my_bolt:
        name: QAAPI
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
            model_name: deepset/deberta-v3-base-squad2
            model_class: AutoModelForQuestionAnswering
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

After setting up your `genius.yml`, launch your API with:

```bash
genius rise
```

<iframe width="800" height="500" src="https://www.youtube-nocookie.com/embed/vgWKoYp_miM?si=Mb9ZwEOhknyQOWbX" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Understanding `genius.yml`

Each parameter in the `genius.yml` file is crucial for customizing your QA API:

- **model_name**: The model identifier from Hugging Face, tailored to your specific QA task.
- **use_cuda**: Toggle GPU acceleration (`true` or `false`). Using GPUs can drastically reduce inference time.
- **precision**: Model precision (`float` for single precision). Adjusting this can affect performance and accuracy, e.g. to `bfloat16`.
- **device_map**: Assigns model parts to specific GPUs, useful for systems with multiple GPUs. `cuda:0` implies use GPU 0.
- **endpoint & port**: Defines where your API is hosted, allowing for easy access.
- **username** & **password**: Secure your API with basic authentication.

## Use Cases & Variations

**Replacing Model for Different QA Tasks**

To adapt the API for various QA tasks, simply change the `model_name` in your `genius.yml`. For example, to switch to a model specializing in medical QA, you might use `bert-large-uncased-whole-word-masking-finetuned-squad` for broader coverage of medical inquiries.

**Example `genius.yml` for a Different Use Case:**

```yml
args:
  model_name: "bert-large-uncased-whole-word-masking-finetuned-squad"
```

## Making API Requests

Geniusrise enables two primary ways to interact with your Question Answering API: through direct question-answering and utilizing the Hugging Face pipeline. Below, we provide examples on how to use both endpoints using `curl` and `python-requests`.

### Direct Question Answering API

This API endpoint directly answers questions based on the provided context.

**Using `curl`:**

```bash
/usr/bin/curl -X POST localhost:3000/api/v1/answer \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "data": "Theres something magical about Recurrent Neural Networks (RNNs). I still remember when I trained my first recurrent network for Image Captioning. Within a few dozen minutes of training my first baby model (with rather arbitrarily-chosen hyperparameters) started to generate very nice looking descriptions of images that were on the edge of making sense. Sometimes the ratio of how simple your model is to the quality of the results you get out of it blows past your expectations, and this was one of those times. What made this result so shocking at the time was that the common wisdom was that RNNs were supposed to be difficult to train (with more experience Ive in fact reached the opposite conclusion). Fast forward about a year: Im training RNNs all the time and Ive witnessed their power and robustness many times, and yet their magical outputs still find ways of amusing me.",
        "question": "What is the common wisdom about RNNs?"

    }' | jq
```

**Using `python-requests`:**

```python
import requests

data = {
  "data": "Theres something magical about Recurrent Neural Networks (RNNs). I still remember when I trained my first recurrent network for Image Captioning. Within a few dozen minutes of training my first baby model (with rather arbitrarily-chosen hyperparameters) started to generate very nice looking descriptions of images that were on the edge of making sense. Sometimes the ratio of how simple your model is to the quality of the results you get out of it blows past your expectations, and this was one of those times. What made this result so shocking at the time was that the common wisdom was that RNNs were supposed to be difficult to train (with more experience Ive in fact reached the opposite conclusion). Fast forward about a year: Im training RNNs all the time and Ive witnessed their power and robustness many times, and yet their magical outputs still find ways of amusing me.",
  "question": "What is the common wisdom about RNNs?"
}

response = requests.post("http://localhost:3000/api/v1/answer",
                         json=data,
                         auth=('user', 'password'))
print(response.json())
```

### Hugging Face Pipeline API

This API endpoint leverages the Hugging Face pipeline for answering questions, offering a streamlined way to use pre-trained models for question answering.

**Using `curl`:**

```bash
curl -X POST http://localhost:3000/api/v1/answer_pipeline \
     -H "Content-Type: application/json" \
     -u "user:password" \
     -d '{"question": "Who created Geniusrise?", "data": "Geniusrise was created by a team of dedicated developers."}'
```

**Using `python-requests`:**

```python
import requests

data = {
  "question": "Who created Geniusrise?",
  "data": "Geniusrise was created by a team of dedicated developers."
}

response = requests.post("http://localhost:3000/api/v1/answer_pipeline",
                         json=data,
                         auth=('user', 'password'))
print(response.json())
```

## Fun

### Long contexts

An usual problem that faces QA models is small context sizes. This limits the model's capabilities for processing large documents or large amounts of text in their inputs. Though language models keep getting bigger contexts, QA models on the other hand tend to be much smaller and support smaller contexts.

However there are exceptions like this one:

```yml
version: "1"

bolts:
    my_bolt:
        name: QAAPI
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
            model_name: valhalla/longformer-base-4096-finetuned-squadv1
            model_class: AutoModelForQuestionAnswering
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
/usr/bin/curl -X POST localhost:3000/api/v1/answer \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "data": "Theres something magical about Recurrent Neural Networks (RNNs). I still remember when I trained my first recurrent network for Image Captioning. Within a few dozen minutes of training my first baby model (with rather arbitrarily-chosen hyperparameters) started to generate very nice looking descriptions of images that were on the edge of making sense. Sometimes the ratio of how simple your model is to the quality of the results you get out of it blows past your expectations, and this was one of those times. What made this result so shocking at the time was that the common wisdom was that RNNs were supposed to be difficult to train (with more experience Ive in fact reached the opposite conclusion). Fast forward about a year: Im training RNNs all the time and Ive witnessed their power and robustness many times, and yet their magical outputs still find ways of amusing me. This post is about sharing some of that magic with you. By the way, together with this post I am also releasing code on Github that allows you to train character-level language models based on multi-layer LSTMs. You give it a large chunk of text and it will learn to generate text like it one character at a time. You can also use it to reproduce my experiments below. But we’re getting ahead of ourselves; What are RNNs anyway? Recurrent Neural Networks Sequences. Depending on your background you might be wondering: What makes Recurrent Networks so special? A glaring limitation of Vanilla Neural Networks (and also Convolutional Networks) is that their API is too constrained: they accept a fixed-sized vector as input (e.g. an image) and produce a fixed-sized vector as output (e.g. probabilities of different classes). Not only that: These models perform this mapping using a fixed amount of computational steps (e.g. the number of layers in the model). The core reason that recurrent nets are more exciting is that they allow us to operate over sequences of vectors: Sequences in the input, the output, or in the most general case both. A few examples may make this more concrete: Each rectangle is a vector and arrows represent functions (e.g. matrix multiply). Input vectors are in red, output vectors are in blue and green vectors hold the RNNs state (more on this soon). From left to right: (1) Vanilla mode of processing without RNN, from fixed-sized input to fixed-sized output (e.g. image classification). (2) Sequence output (e.g. image captioning takes an image and outputs a sentence of words). (3) Sequence input (e.g. sentiment analysis where a given sentence is classified as expressing positive or negative sentiment). (4) Sequence input and sequence output (e.g. Machine Translation: an RNN reads a sentence in English and then outputs a sentence in French). (5) Synced sequence input and output (e.g. video classification where we wish to label each frame of the video). Notice that in every case are no pre-specified constraints on the lengths sequences because the recurrent transformation (green) is fixed and can be applied as many times as we like. As you might expect, the sequence regime of operation is much more powerful compared to fixed networks that are doomed from the get-go by a fixed number of computational steps, and hence also much more appealing for those of us who aspire to build more intelligent systems. Moreover, as we’ll see in a bit, RNNs combine the input vector with their state vector with a fixed (but learned) function to produce a new state vector. This can in programming terms be interpreted as running a fixed program with certain inputs and some internal variables. Viewed this way, RNNs essentially describe programs. In fact, it is known that RNNs are Turing-Complete in the sense that they can to simulate arbitrary programs (with proper weights). But similar to universal approximation theorems for neural nets you shouldn’t read too much into this. In fact, forget I said anything.",
        "question": "What do the models essentially do?"
    }' | jq

# {
#   "data": "Theres something magical about Recurrent Neural Networks (RNNs). I still remember when I trained my first recurrent network for Image Captioning. Within a few dozen minutes of training my first baby model (with rather arbitrarily-chosen hyperparameters) started to generate very nice looking descriptions of images that were on the edge of making sense. Sometimes the ratio of how simple your model is to the quality of the results you get out of it blows past your expectations, and this was one of those times. What made this result so shocking at the time was that the common wisdom was that RNNs were supposed to be difficult to train (with more experience Ive in fact reached the opposite conclusion). Fast forward about a year: Im training RNNs all the time and Ive witnessed their power and robustness many times, and yet their magical outputs still find ways of amusing me. This post is about sharing some of that magic with you. By the way, together with this post I am also releasing code on Github that allows you to train character-level language models based on multi-layer LSTMs. You give it a large chunk of text and it will learn to generate text like it one character at a time. You can also use it to reproduce my experiments below. But we’re getting ahead of ourselves; What are RNNs anyway? Recurrent Neural Networks Sequences. Depending on your background you might be wondering: What makes Recurrent Networks so special? A glaring limitation of Vanilla Neural Networks (and also Convolutional Networks) is that their API is too constrained: they accept a fixed-sized vector as input (e.g. an image) and produce a fixed-sized vector as output (e.g. probabilities of different classes). Not only that: These models perform this mapping using a fixed amount of computational steps (e.g. the number of layers in the model). The core reason that recurrent nets are more exciting is that they allow us to operate over sequences of vectors: Sequences in the input, the output, or in the most general case both. A few examples may make this more concrete: Each rectangle is a vector and arrows represent functions (e.g. matrix multiply). Input vectors are in red, output vectors are in blue and green vectors hold the RNNs state (more on this soon). From left to right: (1) Vanilla mode of processing without RNN, from fixed-sized input to fixed-sized output (e.g. image classification). (2) Sequence output (e.g. image captioning takes an image and outputs a sentence of words). (3) Sequence input (e.g. sentiment analysis where a given sentence is classified as expressing positive or negative sentiment). (4) Sequence input and sequence output (e.g. Machine Translation: an RNN reads a sentence in English and then outputs a sentence in French). (5) Synced sequence input and output (e.g. video classification where we wish to label each frame of the video). Notice that in every case are no pre-specified constraints on the lengths sequences because the recurrent transformation (green) is fixed and can be applied as many times as we like. As you might expect, the sequence regime of operation is much more powerful compared to fixed networks that are doomed from the get-go by a fixed number of computational steps, and hence also much more appealing for those of us who aspire to build more intelligent systems. Moreover, as we’ll see in a bit, RNNs combine the input vector with their state vector with a fixed (but learned) function to produce a new state vector. This can in programming terms be interpreted as running a fixed program with certain inputs and some internal variables. Viewed this way, RNNs essentially describe programs. In fact, it is known that RNNs are Turing-Complete in the sense that they can to simulate arbitrary programs (with proper weights). But similar to universal approximation theorems for neural nets you shouldn’t read too much into this. In fact, forget I said anything.",
#   "question": "What do the models essentially do?",
#   "answer": {
#     "answers": [
#       "they allow us to operate over sequences of vectors" <---
#     ],
#     "aggregation": "NONE"
#   }
# }
```

### Domain-specific

QA models can also be trained to be better at answering questions at chosen domains. This one is optimized for healthcare:

```yml
version: "1"

bolts:
    my_bolt:
        name: QAAPI
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
            model_name: dmis-lab/biobert-large-cased-v1.1-squad
            model_class: AutoModelForQuestionAnswering
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
/usr/bin/curl -X POST localhost:3000/api/v1/answer \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "data": "The choice of medication or combination of medications depends on various factors, including your personal risk factors, your age, your health and possible drug side effects. Common choices include:  Statins. Statins block a substance your liver needs to make cholesterol. This causes your liver to remove cholesterol from your blood. Choices include atorvastatin, fluvastatin, lovastatin, pitavastatin, rosuvastatin and simvastatin. Cholesterol absorption inhibitors. The drug ezetimibe helps reduce blood cholesterol by limiting the absorption of dietary cholesterol. Ezetimibe can be used with a statin drug. Bempedoic acid. This newer drug works in much the same way as statins but is less likely to cause muscle pain. Adding bempedoic acid to a maximum statin dosage can help lower LDL significantly. A combination pill containing both bempedoic acid and ezetimibe also is available. Bile-acid-binding resins. Your liver uses cholesterol to make bile acids, a substance needed for digestion. The medications cholestyramine, colesevelam and colestipol lower cholesterol indirectly by binding to bile acids. This prompts your liver to use excess cholesterol to make more bile acids, which reduces the level of cholesterol in your blood. PCSK9 inhibitors. These drugs can help the liver absorb more LDL cholesterol, which lowers the amount of cholesterol circulating in your blood. Alirocumab and evolocumab might be used for people who have a genetic condition that causes very high levels of LDL or in people with a history of coronary disease who have intolerance to statins or other cholesterol medications. They are injected under the skin every few weeks and are expensive. Medications for high triglycerides If you also have high triglycerides, your doctor might prescribe:  Fibrates. The medications fenofibrate and gemfibrozil reduce your liver s production of very-low-density lipoprotein cholesterol and speed the removal of triglycerides from your blood. VLDL cholesterol contains mostly triglycerides. Using fibrates with a statin can increase the risk of statin side effects. Omega-3 fatty acid supplements. Omega-3 fatty acid supplements can help lower your triglycerides. They are available by prescription or over-the-counter.",
        "question": "What do i take if i have high VLDL?"
    }' | jq

# {
#   "data": "The choice of medication or combination of medications depends on various factors, including your personal risk factors, your age, your health and possible drug side effects. Common choices include:  Statins. Statins block a substance your liver needs to make cholesterol. This causes your liver to remove cholesterol from your blood. Choices include atorvastatin, fluvastatin, lovastatin, pitavastatin, rosuvastatin and simvastatin. Cholesterol absorption inhibitors. The drug ezetimibe helps reduce blood cholesterol by limiting the absorption of dietary cholesterol. Ezetimibe can be used with a statin drug. Bempedoic acid. This newer drug works in much the same way as statins but is less likely to cause muscle pain. Adding bempedoic acid to a maximum statin dosage can help lower LDL significantly. A combination pill containing both bempedoic acid and ezetimibe also is available. Bile-acid-binding resins. Your liver uses cholesterol to make bile acids, a substance needed for digestion. The medications cholestyramine, colesevelam and colestipol lower cholesterol indirectly by binding to bile acids. This prompts your liver to use excess cholesterol to make more bile acids, which reduces the level of cholesterol in your blood. PCSK9 inhibitors. These drugs can help the liver absorb more LDL cholesterol, which lowers the amount of cholesterol circulating in your blood. Alirocumab and evolocumab might be used for people who have a genetic condition that causes very high levels of LDL or in people with a history of coronary disease who have intolerance to statins or other cholesterol medications. They are injected under the skin every few weeks and are expensive. Medications for high triglycerides If you also have high triglycerides, your doctor might prescribe:  Fibrates. The medications fenofibrate and gemfibrozil reduce your liver s production of very-low-density lipoprotein cholesterol and speed the removal of triglycerides from your blood. VLDL cholesterol contains mostly triglycerides. Using fibrates with a statin can increase the risk of statin side effects. Omega-3 fatty acid supplements. Omega-3 fatty acid supplements can help lower your triglycerides. They are available by prescription or over-the-counter.",
#   "question": "What do i take if i have high VLDL?",
#   "answer": {
#     "answers": [
#       "fibrates"  <-------
#     ],
#     "aggregation": "NONE"
#   }
# }
```

Now there are also models like the [sloshed lawyer](NextLaoHuang/RWKV-Sloshed-Lawyer) but they are not recommended in production 😆

## Play around

There are 9,593 QA models [huggingface](https://huggingface.co/models?pipeline_tag=question-answering), go exlpore!
