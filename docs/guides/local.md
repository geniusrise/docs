# Local setup

Lets create a workspace for local experimentation. We will not build anything here, just try to use whatever components are available. This is what a low-code workflow could look like.

Lets create a workflow in which:

1. A web server listens for all kinds of HTTP events.
2. Clients send the following information to the server:
   1. HTTP request
   2. Response and response status code
3. The server buffers events in batches of 1000 and uploads them on to s3.
4. Train a small LLM model on the data to be used to predict whether the request was valid.

A representation of the process using a sequence diagram:

```puml
@startuml

skinparam backgroundColor #0d0816
skinparam ArrowColor #ffffff
skinparam defaultFontColor #ffffff
skinparam SequenceLifeLineBorderColor #ffffff
skinparam actorStyle awesome


skinparam actor {
  BackgroundColor #f34960
  FontColor #0d0816
}

skinparam participant {
  BackgroundColor #e667aa
  FontColor #0d0816
}

actor Client

database "S3 Bucket" as S3
participant "Listen for HTTP Events" as Listen
participant "Buffer Events" as Buffer
participant "Upload to S3" as Upload
participant "Load Data from S3" as LoadData
participant "Fine-tune LLM Model" as FineTune
participant "Save Model" as UploadModel

Client -> Listen : Send HTTP Request
Listen -> Buffer : Buffer Events
Buffer -> Upload : Batch of 1000 Events
Upload -> S3 : Upload Data
S3 -> LoadData : Fetch Data
LoadData -> FineTune : Train Model
FineTune -> UploadModel : Upload Trained Model
UploadModel -> S3 : Save Model

@enduml
```

This model could be used to predict if a request will fail before serving it. It could also be used to classify requests as malicious etc.

## Install

Let's start by installing geniusrise and itc components in a local virtual environment.

1. Create a directory:

```bash
mkdir test
cd test
```

2. Create a virtualenv:

```bash
virtualenv venv
source venv/bin/activate
```

3. Install geniursise

```bash
pip install geniusrise
pip install geniusrise-listeners
pip install geniusrise-huggingface
```

4. Save the installed package versions

```bash
pip freeze > requirements.txt
```

5. Verify if everything is installed:

```bash
$ genius list

+--------------------------------------------+-------+
| Name                                       | Type  |
+--------------------------------------------+-------+
| TestSpoutCtlSpout                          | Spout |
| Kafka                                      | Spout |
| MQTT                                       | Spout |
| Quic                                       | Spout |
| RESTAPIPoll                                | Spout |
| RabbitMQ                                   | Spout |
| RedisPubSub                                | Spout |
| RedisStream                                | Spout |
| SNS                                        | Spout |
| SQS                                        | Spout |
| Udp                                        | Spout |
| Webhook                                    | Spout |
| Websocket                                  | Spout |
| TestBoltCtlBolt                            | Bolt  |
| HuggingFaceClassificationFineTuner         | Bolt  |
| HuggingFaceCommonsenseReasoningFineTuner   | Bolt  |
| HuggingFaceFineTuner                       | Bolt  |
| HuggingFaceInstructionTuningFineTuner      | Bolt  |
| HuggingFaceLanguageModelingFineTuner       | Bolt  |
| HuggingFaceNamedEntityRecognitionFineTuner | Bolt  |
| HuggingFaceQuestionAnsweringFineTuner      | Bolt  |
| HuggingFaceSentimentAnalysisFineTuner      | Bolt  |
| HuggingFaceSummarizationFineTuner          | Bolt  |
| HuggingFaceTranslationFineTuner            | Bolt  |
| NamedEntityRecognitionFineTuner            | Bolt  |
| OpenAIClassificationFineTuner              | Bolt  |
| OpenAICommonsenseReasoningFineTuner        | Bolt  |
| OpenAIFineTuner                            | Bolt  |
| OpenAIInstructionFineTuner                 | Bolt  |
| OpenAILanguageModelFineTuner               | Bolt  |
| OpenAIQuestionAnsweringFineTuner           | Bolt  |
| OpenAISentimentAnalysisFineTuner           | Bolt  |
| OpenAISummarizationFineTuner               | Bolt  |
| OpenAITranslationFineTuner                 | Bolt  |
+--------------------------------------------+-------+
```

## Input Data

Lets start with the server which has to listen for HTTP events. We can use the `Webhook` listener for this purpose.

Next, we have to ask ourselves 2 things:

1. Where do we want the output?
   1. A: in s3 in batches (output = stream_to_batch)
2. Do we want monitoring?
   1. A: no (state = none)

Let's run the listener:

```bash
genius Webhook rise \
  stream_to_batch \
  --output_s3_bucket geniusrise-test \
  --output_s3_folder train \
  none \
  listen \
  --args port=8080
```

The server should be up with:

```bash
    🚀 Initialized Task with ID: Webhookaca9cb67-5c41-420c-9445-cf0015d9d866
    [17/Sep/2023:14:00:18] ENGINE Bus STARTING
CherryPy Checker:
The Application mounted at '' has an empty config.

    [17/Sep/2023:14:00:18] ENGINE Started monitor thread 'Autoreloader'.
    [17/Sep/2023:14:00:18] ENGINE Serving on http://0.0.0.0:8080
    [17/Sep/2023:14:00:18] ENGINE Bus STARTED
```

## Data

Lets create some data for testing:

```bash
while true; do
  # Generate a random customer ID
  customer_id=$(( RANDOM % 10000001 ))

  # Determine the status code based on the customer ID
  if [ $customer_id -gt 10000000 ]; then
    status_code="1"
  elif [ $customer_id -le 10000 ]; then
    status_code="1"
  else
    status_code="0"
  fi

  # Make the API call
  curl --header "Content-Type: application/json" \
       --request POST \
       --data "{\"text\":\"GET /api/v1/customer/$customer_id\",\"label\":\"$status_code\"}" \
       http://localhost:8080/application-1-tag-a-tag-b-whatever
done
```

Verify that the data is being dumped in the right place with the correct format:

```bash
$ aws s3 ls s3://geniusrise-test/train/

2023-08-11 14:02:47      28700 DGtx4KjVZw5C2gfWmTVCmD.json
2023-08-11 14:02:50      28700 UYXAvn8JC2yk6pMuAjKMPq.json
```

The Webhook spout generates data like this:

```python
{'data': {'text': 'GET /api/v1/customer/28546', 'label': '401'},
  'endpoint': 'http://localhost:8080/application-1-tag-a-tag-b-whatever',
  'headers': {'Remote-Addr': '127.0.0.1',
   'Host': 'localhost:8080',
   'User-Agent': 'curl/8.1.2',
   'Accept': '*/*',
   'Content-Type': 'application/json',
   'Content-Length': '51'}}
```

We need to extract the `data` field from this data before training. This can be done by passing a lambda `lambda x: x['data']` to the fine tuning bolt.

More info on other arguments can be found with:

```bash
genius Webhook rise --help
```

## Fine-tuning

Now lets test the second leg of this, the model. Since we want to use the model for predicting the status code given the data, we will use classification as our task for fine-tuning the model.

Lets use the `bert-base-uncased` model for now, as it is small enough to run on a CPU on a laptop.
We also create a model on huggingface hub to store the model once it is trained: `ixaxaar/geniusrise-api-status-code-prediction`.

```bash
genius HuggingFaceClassificationFineTuner rise \
    batch \
    --input_s3_bucket geniusrise-test \
    --input_s3_folder train \
    batch \
    --output_s3_bucket geniusrise-test \
    --output_s3_folder api-prediction \
    none \
    fine_tune \
    --args \
        model_name="bert-base-uncased" \
        tokenizer_name="bert-base-uncased" \
        num_train_epochs=2 \
        per_device_train_batch_size=64 \
        model_class=BertForSequenceClassification \
        tokenizer_class=BertTokenizer \
        data_masked=True \
        data_extractor_lambda="lambda x: x['data']" \
        hf_repo_id=ixaxaar/geniusrise-api-status-code-prediction \
        hf_commit_message="initial local testing" \
        hf_create_pr=True \
        hf_token=hf_lalala

```

```
    🚀 Initialized Task with ID: HuggingFaceClassificationFineTuner772627a0-43a5-4f9d-9b0f-4362d69ba08c
    Found credentials in shared credentials file: ~/.aws/credentials
Some weights of BertForSequenceClassification were not initialized from the model checkpoint at bert-base-uncased and are newly initialized: ['classifier.bias', 'classifier.weight']
You should probably TRAIN this model on a down-stream task to be able to use it for predictions and inference.
    Loading dataset from /tmp/tmp3h3wav4h/train
    New labels detected, ignore if fine-tuning
Map: 100%|██████████████████████████| 300/300 [00:00<00:00, 4875.76 examples/s]
{'train_runtime': 13.3748, 'train_samples_per_second': 44.861, 'train_steps_per_second': 22.43, 'train_loss': 0.6400579833984374, 'epoch': 2.0}
100%|████████████████████████████████████████| 300/300 [00:13<00:00, 22.43it/s]
pytorch_model.bin: 100%|████████████████████| 438M/438M [01:29<00:00, 4.88MB/s]
    Successfully executed the bolt method: fine_tune 👍
```

You'll see a progress bar at the bottom, on completion, a pull request will appear on huggingface hub.
Here is the model we trained: [https://huggingface.co/ixaxaar/geniusrise-api-status-code-prediction](https://huggingface.co/ixaxaar/geniusrise-api-status-code-prediction).

## Packaging

Finally, lets package this workflow so that we can run it again and again.

Create a `genius.yml` file, similar to the cli commands:

```yaml
version: 1

spouts:
  http_listener:
    name: Webhook
    method: listen
      args:
        port: 8080
    state:
      type: none
    output:
      type: stream_to_batch
      args:
        bucket: geniusrise-test
        folder: train

  http_classifier:
    name: HuggingFaceClassificationFineTuner
    method: fine_tune
      args:
        model_name: "bert-base-uncased"
        tokenizer_name: "bert-base-uncased"
        num_train_epochs: 2
        per_device_train_batch_size: 2
        model_class: BertForSequenceClassification
        tokenizer_class: BertTokenizer
        data_masked: True
        data_extractor_lambda: "lambda x: x['data']"
        hf_repo_id: ixaxaar/geniusrise-api-status-code-prediction
        hf_commit_message: "initial local testing"
        hf_create_pr: True
        hf_token: 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
    input:
      type: spout
        args:
          name: http_listener
    output:
      type: batch
      args:
        bucket: geniusrise-test
        folder: model
```

Finally run them:

```bash
genius rise
```

Or run them individually:

```bash
genius rise --spout all
genius rise --bolt all
```