![banner](./assets/logo_with_text.png)

---

# Geniusrise Agent Ecosystem

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
3. 📦 [**Packaging**](guides/packaging.md) - <span style="color:#e667aa">Packaging your application.</span>
4. 🚀 [**Deployment**](guides/deployment.md) - <span style="color:#e667aa">Deploying parts or whole of your application.</span>
<!-- 5. ⚙️ [**Workflow Ops**](guides/index.md) - <span style="color:#e667aa">Operations and management of workflows.</span>
6. 📊 [**Data Ops**](guides/index.md) - <span style="color:#e667aa">Operations and management of data.</span>
7. 🤖 [**Model Ops**](guides/index.md) - <span style="color:#e667aa">Operations and management of models.</span> -->

### 📚 <span style="color:#f34960">Reference</span>

---

1. 📄 [**YAML Structure**](guides/yaml.md) - <span style="color:#e667aa">Geniusfile structure and configuration.</span>
2. 🌐 [**CLI reference**](guides/cli.md) - <span style="color:#e667aa">Command line reference.</span>
3. 🎨 [**Project Templates**](guides/index.md) - <span style="color:#e667aa">Project templates for community plugins.</span>

### 🏃 Runners

| 🌐 **Runners**                              |                                      |                              |                                        |
| ------------------------------------------ | ------------------------------------ | ---------------------------- | -------------------------------------- |
| 🟢 [k8s deployment](core/k8s_deployment.md) | 🟤 [k8s service](core/k8s_service.md) | 🟡 [k8s job](core/k8s_job.md) | 🟠 [k8s cron job](core/k8s_cron_job.md) |
| 🟧 [k8s pods](core/k8s_base.md)             |                                      |                              |                                        |


<!-- |                                       | 🟣 [~Apache Airflow~](guides/index.md) | 🔵 [~AWS Fargate~](guides/index.md) | 🟥 [~AWS ECS~](guides/index.md)         | 🟩 [~AWS Batch~](guides/index.md) | | -->


### 🌪️ Spouts

| 🌐 **Streaming**                            |                                    |                                    |                                          |
| ------------------------------------------ | ---------------------------------- | ---------------------------------- | ---------------------------------------- |
| 🟢 [Http Polling](spouts/http_polling.md)   | 🟣 [Socket.io](spouts/socket.io.md) | 🟡 [gRPC](spouts/grpc.md)           | 🟠 [QUIC](spouts/quic.md)                 |
| 🟤 [UDP](spouts/udp.md)                     | 🔵 [Webhook](spouts/webhook.md)     | 🟥 [Websocket](spouts/websocket.md) | 🟩 [SNS](spouts/sns.md)                   |
| 🟧 [SQS](spouts/sqs.md)                     | 🟨 [AMQP](spouts/amqp.md)           | 🟫 [Kafka](spouts/kafka.md)         | 🟪 [Kinesis Streams](spouts/kinesis.md)   |
| 🟩 [MQTT](spouts/mqtt.md)                   | 🟨 [ActiveMQ](spouts/activemq.md)   | 🟫 [ZeroMQ](spouts/zeromq.md)       | 🟪 [Redis Pubsub](spouts/redis_pubsub.md) |
| 🟧 [Redis Streams](spouts/redis_streams.md) |                                    |                                    |                                          |

| 📦 **Databases**                           |                                                   |                                               |                                       |
| ----------------------------------------- | ------------------------------------------------- | --------------------------------------------- | ------------------------------------- |
| 🟢 [HBase](databases/hbase.md)             | 🟣 [PostgreSQL](databases/postgres.md)             | 🔵 [MySQL](databases/mysql.md)                 | 🟠 [MongoDB](databases/mongodb.md)     |
| 🟢 [Cassandra](databases/cassandra.md)     | 🟣 [Redis](databases/redis.md)                     | 🔵 [Elasticsearch](databases/elasticsearch.md) | 🟠 [Oracle](databases/oracle.md)       |
| 🟢 [SQL Server](databases/sql_server.md)   | 🟣 [SQLite](databases/sqlite.md)                   | 🔵 [Neo4j](databases/neo4j.md)                 | 🟠 [Bigtable](databases/bigtable.md)   |
| 🟢 [DynamoDB](databases/dynamodb.md)       | 🟣 [Azure Table Storage](databases/azure_table.md) | 🔵 [Couchbase](databases/couchbase.md)         | 🟠 [InfluxDB](databases/influxdb.md)   |
| 🟢 [TimescaleDB](databases/timescaledb.md) | 🟣 [Teradata](databases/teradata.md)               | 🔵 [TiDB](databases/tidb.md)                   | 🟠 [Voltdb](databases/voltdb.md)       |
| 🟢 [Sybase](databases/sybase.md)           | 🟣 [DB2](databases/db2.md)                         | 🔵 [AWS Presto](databases/presto.md)           | 🟠 [Riak](databases/riak.md)           |
| 🟢 [MemSQL](databases/memsql.md)           | 🟣 [LDAP](databases/ldap.md)                       | 🔵 [AWS KeySpaces](databases/keyspaces.md)     | 🟠 [KairosDB](databases/kairosdb.md)   |
| 🟢 [Graphite](databases/graphite.md)       | 🟣 [Google FireStore](databases/firestore.md)      | 🔵 [AWS DocumentDB](databases/documentdb.md)   | 🟠 [Cockroach](databases/cockroach.md) |
| 🟢 [Cloud SQL](databases/cloud_sql.md)     | 🟣 [Azure CosmosDB](databases/cosmosdb.md)         | 🔵 [AWS Athena](databases/athena.md)           | 🟠 [ArangoDB](databases/arangodb.md)   |
| 🟢 [Nuodb](databases/nuodb.md)             | 🟣 [OpenTSDB](databases/opentsdb.md)               | 🔵 [Google Bigquery](databases/bigquery.md)    | 🟠 [Vertica](databases/vertica.md)     |
| 🟢 [Google Spanner](databases/spanner.md)  |                                                   |                                               |                                       |

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

| 📦 **cli**                            | 📦 **core**                       | 📦 **data**                                                           | 📦 **core.state**                              |
| ------------------------------------ | -------------------------------- | -------------------------------------------------------------------- | --------------------------------------------- |
| 🟠 [geniusctl](core/cli_geniusctl.md) | 🟢 [bolt](core/core_bolt.md)      | 🟣 [input](core/core_data_input.md)                                   | 🔴 [base](core/core_state_base.md)             |
| 🟠 [yamlctl](core/cli_yamlctl.md)     | 🟢 [spout](core/core_spout.md)    | 🟣 [output](core/core_data_output.md)                                 | 🔴 [dynamo](core/core_state_dynamo.md)         |
| 🟠 [boltctl](core/cli_boltctl.md)     | 🟤 [base](core/core_task_base.md) | 🟣 [batch_input](core/core_data_batch_input.md)                       | 🔴 [memory](core/core_state_memory.md)         |
| 🟠 [spoutctl](core/cli_spoutctl.md)   |                                  | 🟣 [batch_output](core/core_data_batch_output.md)                     | 🔴 [postgres](core/core_state_postgres.md)     |
| 🟠 [schema](core/cli_schema.md)       |                                  | 🟣 [streaming_input](core/core_data_streaming_input.md)               | 🔴 [redis](core/core_state_redis.md)           |
| 🟠 [discover](core/cli_discover.md)   |                                  | 🟣 [streaming_output](core/core_data_streaming_output.md)             | 🔴 [prometheus](core/core_state_prometheus.md) |
| 🟠 [docker](core/cli_dockerctl.md)    |                                  | 🟣 [stream_to_batch_input](core/core_data_stream_to_batch_input.md)   |                                               |
|                                      |                                  | 🟣 [stream_to_batch_output](core/core_data_stream_to_batch_output.md) |                                               |
|                                      |                                  | 🟣 [batch_to_stream_input](core/core_data_batch_to_stream_input.md)   |                                               |
