![banner](./assets/sc1.jpg)

# Geniusrise Agent Framework

## About

---

Geniusrise is a modular, loosely-coupled AgentOps / MLOps framework designed for the era of Large Language Models, offering flexibility, inclusivity, and standardization in designing networks of AI agents.

It seamlessly integrates tasks, state management, data handling, and model versioning, all while supporting diverse infrastructures and user expertise levels. With its plug-and-play architecture, Geniusrise empowers teams to build, share, and deploy AI agent workflows across various platforms efficiently.

## Guides

---

### 🚀 <span style="color:#f34960">Getting Started</span>

---

1. 📘 [**Concepts**](guides/concepts.md) - <span style="color:#e667aa">Concepts of the framework, start here.</span>
2. 🏗️ [**Architecture**](guides/architecture.md) - <span style="color:#e667aa">Design and architecture of the framework.</span>
3. 🛠️ [**Installation**](guides/installation.md) - <span style="color:#e667aa">Installation and setup.</span>

### 💻 <span style="color:#f34960">Development</span>

---

1. 🏠 [**Local Experimentation**](guides/local.md) - <span style="color:#e667aa">Local setup and project creation.</span>
2. 🔄 [**Dev Cycle**](guides/dev_cycle.md) - <span style="color:#e667aa">Describes one full local development cycle.</span>
3. 📦 [**Packaging**](guides/index.md) - <span style="color:#e667aa">Packaging your application.</span>
4. 🚀 [**Deployment**](guides/index.md) - <span style="color:#e667aa">Deploying parts or whole of your application.</span>
5. ⚙️ [**Workflow Ops**](guides/index.md) - <span style="color:#e667aa">Operations and management of workflows.</span>
6. 📊 [**Data Ops**](guides/index.md) - <span style="color:#e667aa">Operations and management of data.</span>
7. 🤖 [**Model Ops**](guides/index.md) - <span style="color:#e667aa">Operations and management of models.</span>

### 📚 <span style="color:#f34960">Reference</span>

---

1. 📄 [**YAML Structure**](guides/index.md) - <span style="color:#e667aa">Geniusfile structure and configuration.</span>
2. 🌐 [**Community Plugins**](guides/plugins.md) - <span style="color:#e667aa">Building and shipping community plugins (spouts and bolts).</span>
3. 🎨 [**Project Templates**](guides/index.md) - <span style="color:#e667aa">Project templates for community plugins.</span>

### 🚀 Deployment

| 🌐 **Runners**                     |                                     |                                   |
| --------------------------------- | ----------------------------------- | --------------------------------- |
| 🟢 [Kubernetes](guides/index.md)   | 🟣 [Apache Airflow](guides/index.md) | 🟡 [Apache Spark](guides/index.md) |
| 🟠 [Apache Flink](guides/index.md) | 🟤 [Apache Beam](guides/index.md)    | 🔵 [Apache Storm](guides/index.md) |
| 🟥 [AWS ECS](guides/index.md)      | 🟩 [AWS Batch](guides/index.md)      |                                   |

### 🌪️ Spouts

| 🌐 **Streaming**                          |                                            |                                        |
| ---------------------------------------- | ------------------------------------------ | -------------------------------------- |
| 🟢 [Http Polling](spouts/http_polling.md) | 🟣 [Socket.io](spouts/socket.io.md)         | 🟡 [gRPC](spouts/grpc.md)               |
| 🟠 [QUIC](spouts/quic.md)                 | 🟤 [UDP](spouts/udp.md)                     | 🔵 [Webhook](spouts/webhook.md)         |
| 🟥 [Websocket](spouts/websocket.md)       | 🟩 [SNS](spouts/sns.md)                     | 🟧 [SQS](spouts/sqs.md)                 |
| 🟨 [AMQP](spouts/amqp.md)                 | 🟫 [Kafka](spouts/kafka.md)                 | 🟪 [Kinesis Streams](spouts/kinesis.md) |
| 🟩 [MQTT](spouts/mqtt.md)                 | 🟨 [ActiveMQ](spouts/activemq.md)           | 🟫 [ZeroMQ](spouts/zeromq.md)           |
| 🟪 [Redis Pubsub](spouts/redis_pubsub.md) | 🟧 [Redis Streams](spouts/redis_streams.md) |                                        |

### ⚡ Bolts

| 🌐 **Huggingface - Fine tuning**                                 |                                                                       |                                                                 |
| --------------------------------------------------------------- | --------------------------------------------------------------------- | --------------------------------------------------------------- |
| 🟢 [Language Model](bolts/huggingface/language_model.md)         | 🟣 [Named Entity Recognition](bolts/huggingface/ner.md)                | 🟡 [Question Answering](bolts/huggingface/question_answering.md) |
| 🟠 [Sentiment Analysis](bolts/huggingface/sentiment_analysis.md) | 🟤 [Summarization](bolts/huggingface/summarization.md)                 | 🟦 [Translation](bolts/huggingface/translation.md)               |
| 🔵 [Classification](bolts/huggingface/classification.md)         | 🔴 [Commonsense Reasoning](bolts/huggingface/commonsense_reasoning.md) | 🟧 [Instruction Tuning](bolts/huggingface/instruction_tuning.md) |
| 🟧 [Base Fine Tuner](bolts/huggingface/base.md)                  |                                                                       |                                                                 |

| 🌐 **OpenAI - Fine tuning**                                 |                                                                  |                                                            |
| ---------------------------------------------------------- | ---------------------------------------------------------------- | ---------------------------------------------------------- |
| 🟢 [Classification](bolts/openai/classification.md)         | 🟣 [Commonsense Reasoning](bolts/openai/commonsense_reasoning.md) | 🟡 [Instruction Tuning](bolts/openai/instruction_tuning.md) |
| 🟠 [Language Model](bolts/openai/language_model.md)         | 🟤 [Named Entity Recognition](bolts/openai/ner.md)                | 🟦 [Question Answering](bolts/openai/question_answering.md) |
| 🔵 [Sentiment Analysis](bolts/openai/sentiment_analysis.md) | 🔴 [Summarization](bolts/openai/summarization.md)                 | 🟧 [Translation](bolts/openai/translation.md)               |
| 🟧 [Base Fine Tuner](bolts/openai/base.md)                  |                                                                  |                                                            |

### 📚 Library

| 📦 **geniusrise.cli**                 | 📦 **geniusrise.core**         | 📦 **geniusrise.core.data**                                           | 📦 **geniusrise.core.state**                   | 📦 **geniusrise.core.task**       | 📦 **geniusrise.runners**       |
| ------------------------------------ | ----------------------------- | -------------------------------------------------------------------- | --------------------------------------------- | -------------------------------- | ------------------------------ |
| 🟠 [geniusctl](core/cli_geniusctl.md) | 🟢 [bolt](core/core_bolt.md)   | 🟣 [input](core/core_data_input.md)                                   | 🔴 [base](core/core_state_base.md)             | 🟤 [base](core/core_task_base.md) | 🔵 [ecs](core/core_task_ecs.md) |
| 🟠 [yamlctl](core/cli_yamlctl.md)     | 🟢 [spout](core/core_spout.md) | 🟣 [output](core/core_data_output.md)                                 | 🔴 [dynamo](core/core_state_dynamo.md)         |                                  | 🔵 [k8s](core/core_task_k8s.md) |
| 🟠 [boltctl](core/cli_boltctl.md)     |                               | 🟣 [batch_input](core/core_data_batch_input.md)                       | 🔴 [memory](core/core_state_memory.md)         |                                  |                                |
| 🟠 [spoutctl](core/cli_spoutctl.md)   |                               | 🟣 [batch_output](core/core_data_batch_output.md)                     | 🔴 [postgres](core/core_state_postgres.md)     |                                  |                                |
| 🟠 [schema](core/cli_schema.md)       |                               | 🟣 [streaming_input](core/core_data_streaming_input.md)               | 🔴 [redis](core/core_state_redis.md)           |                                  |                                |
| 🟠 [discover](core/cli_discover.md)   |                               | 🟣 [streaming_output](core/core_data_streaming_output.md)             | 🔴 [prometheus](core/core_state_prometheus.md) |                                  |                                |
|                                      |                               | 🟣 [stream_to_batch_input](core/core_data_stream_to_batch_input.md)   |                                               |                                  |                                |
|                                      |                               | 🟣 [stream_to_batch_output](core/core_data_stream_to_batch_output.md) |                                               |                                  |                                |
|                                      |                               | 🟣 [batch_to_stream_input](core/core_data_batch_to_stream_input.md)   |                                               |                                  |                                |
