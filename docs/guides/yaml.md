# YAML Structure and Operations

The YAML file for Geniusrise is called `Geniusfile.yaml` and it has the following structure:

```yaml
version: 1
spouts:
  <spout_name>:
    name: <spout_name>
    method: <method_name>
    args:
      <key>: <value>
    output:
      type: <output_type>
      args:
        <key>: <value>
    state:
      type: <state_type>
      args:
        <key>: <value>
    deploy:
      type: <deploy_type>
      args:
        <key>: <value>
bolts:
  <bolt_name>:
    name: <bolt_name>
    method: <method_name>
    args:
      <key>: <value>
    input:
      type: <input_type>
      args:
        <key>: <value>
    output:
      type: <output_type>
      args:
        <key>: <value>
    state:
      type: <state_type>
      args:
        <key>: <value>
    deploy:
      type: <deploy_type>
      args:
        <key>: <value>
```

### Example YAML Files

#### Example 1: Basic Spout and Bolt

```yaml
version: 1
spouts:
  TestSpout:
    name: TestSpout
    method: listen
    args:
      port: 8080
    output:
      type: batch
      args:
        bucket: geniusrise-test
        folder: train
    state:
      type: none
    deploy:
      type: k8s
      args:
        kind: job
        name: coretest
        namespace: geniusrise
        image: "geniusrise/geniusrise-core"

bolts:
  TestBolt:
    name: TestBolt
    method: process
    args:
      factor: 2
    input:
      type: batch
      args:
        bucket: geniusrise-test
        folder: train
    output:
      type: batch
      args:
        bucket: geniusrise-test
        folder: output
    state:
      type: none
    deploy:
      type: k8s
      args:
        kind: job
        name: coretest
        namespace: geniusrise
        image: "geniusrise/geniusrise-core"
```

#### Example 2: Spout with Redis State

```yaml
version: 1
spouts:
  RedisSpout:
    name: RedisSpout
    method: listen
    args:
      port: 8080
    output:
      type: streaming
      args:
        output_topic: geniusrise-stream
        kafka_servers: "localhost:9092"
    state:
      type: redis
      args:
        redis_host: "localhost"
        redis_port: 6379
        redis_db: 0
    deploy:
      type: k8s
      args:
        kind: service
        name: redisspout
        namespace: geniusrise
        image: "geniusrise/geniusrise-core"
```

#### Example 3: Bolt with Postgres State and ECS Deployment

```yaml
version: 1
bolts:
  PostgresBolt:
    name: PostgresBolt
    method: process
    args:
      factor: 2
    input:
      type: streaming
      args:
        input_topic: geniusrise-stream
        kafka_servers: "localhost:9092"
    output:
      type: batch
      args:
        bucket: geniusrise-test
        folder: output
    state:
      type: postgres
      args:
        postgres_host: "localhost"
        postgres_port: 5432
        postgres_user: "postgres"
        postgres_password: "password"
        postgres_database: "geniusrise"
        postgres_table: "state_table"
    deploy:
      type: ecs
      args:
        name: postgresbolt
        account_id: "123456789012"
        cluster: "geniusrise-cluster"
        subnet_ids: ["subnet-abc123", "subnet-def456"]
        security_group_ids: ["sg-abc123"]
        log_group: "geniusrise-logs"
        image: "geniusrise/geniusrise-core"
```

#### Example 4: Spout with S3 State and Lambda Deployment

```yaml
version: 1
spouts:
  S3Spout:
    name: S3Spout
    method: listen
    args:
      s3_bucket: geniusrise-data
      s3_prefix: input/
    output:
      type: streaming
      args:
        output_topic: geniusrise-s3-stream
        kafka_servers: "localhost:9092"
    state:
      type: s3
      args:
        state_bucket: geniusrise-state
        state_prefix: s3spout/
    deploy:
      type: lambda
      args:
        function_name: S3SpoutFunction
        role_arn: arn:aws:iam::123456789012:role/execution_role
        runtime: python3.8
        handler: s3spout.handler
```

#### Example 5: Bolt with DynamoDB State and Fargate Deployment

```yaml
version: 1
bolts:
  DynamoBolt:
    name: DynamoBolt
    method: process
    args:
      operation: multiply
      factor: 3
    input:
      type: streaming
      args:
        input_topic: geniusrise-s3-stream
        kafka_servers: "localhost:9092"
    output:
      type: batch
      args:
        bucket: geniusrise-output
        folder: dynamo/
    state:
      type: dynamodb
      args:
        table_name: DynamoStateTable
        region: us-east-1
    deploy:
      type: fargate
      args:
        cluster: geniusrise-fargate
        task_definition: DynamoBoltTask
        launch_type: FARGATE
        subnets: ["subnet-xyz789", "subnet-uvw456"]
```

#### Example 6: Spout and Bolt with Azure Blob Storage and Azure Functions

```yaml
version: 1
spouts:
  AzureBlobSpout:
    name: AzureBlobSpout
    method: listen
    args:
      container_name: geniusrise-input
      storage_account: geniusriseaccount
      storage_key: "your_storage_key_here"
    output:
      type: streaming
      args:
        output_topic: geniusrise-azure-stream
        kafka_servers: "localhost:9092"
    state:
      type: azure_blob
      args:
        container_name: geniusrise-state
        storage_account: geniusriseaccount
        storage_key: "your_storage_key_here"
    deploy:
      type: azure_function
      args:
        function_name: AzureBlobSpoutFunction
        resource_group: geniusrise-rg
        storage_account: geniusriseaccount
        plan: Consumption

bolts:
  AzureBlobBolt:
    name: AzureBlobBolt
    method: process
    args:
      operation: add
      value: 5
    input:
      type: streaming
      args:
        input_topic: geniusrise-azure-stream
        kafka_servers: "localhost:9092"
    output:
      type: azure_blob
      args:
        container_name: geniusrise-output
        storage_account: geniusriseaccount
        storage_key: "your_storage_key_here"
    state:
      type: azure_blob
      args:
        container_name: geniusrise-state
        storage_account: geniusriseaccount
        storage_key: "your_storage_key_here"
    deploy:
      type: azure_function
      args:
        function_name: AzureBlobBoltFunction
        resource_group: geniusrise-rg
        storage_account: geniusriseaccount
        plan: Consumption
```

### Running and Deploying YAML Files

To run the YAML file:

```bash
genius rise
```

To deploy the YAML file:

```bash
genius rise up
```

### Managing Kubernetes Deployments

You can manage Kubernetes deployments using the `genius` CLI. Here are some example commands:

```bash
# Show pods in a namespace
genius pod show --namespace geniusrise --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise

# Scale a deployment
genius pod scale --namespace geniusrise --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise --name testspout --replicas 3

# Delete a deployment
genius pod delete --namespace geniusrise --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise --name testspout
```

### Managing ECS Deployments

You can manage ECS deployments using the `genius` CLI. Here are some example commands:

```bash
# Show tasks in a cluster
genius ecs show --cluster geniusrise-cluster --account_id 123456789012

# Scale a service
genius ecs scale --cluster geniusrise-cluster --account_id 123456789012 --name postgresbolt --desired_count 3

# Delete a service
genius ecs delete --cluster geniusrise-cluster --account_id 123456789012 --name postgresbolt
```

<!-- ### Managing State

You can manage state using the `genius` CLI. Here are some example commands:

```bash
# Show state in a Redis database
genius state show --type redis --host localhost --port 6379 --db 0

# Show state in a Postgres database
genius state show --type postgres --host localhost --port 5432 --user postgres --password password --database geniusrise --table state_table
```

### Monitoring and Logging

You can monitor and log using the `genius` CLI. Here are some example commands:

```bash
# Show logs for a Kubernetes pod
genius log show --namespace geniusrise --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise --name testspout

# Show logs for an ECS task
genius log show --cluster geniusrise-cluster --account_id 123456789012 --name postgresbolt
```
 -->
