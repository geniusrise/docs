![banner](./assets/sci1.jpg)
# Geniusrise Documentation

## About

Geniusrise is a computation framework is designed to support both batch and
streaming data processing asynchronous Directed Acyclic Graphs (DAGs).

## Library Reference

- geniusrise.cli:
    - geniusrise.cli.yamlctl: [apidocs](core/cli_yamlctl.md)
    - geniusrise.cli.geniusctl: [apidocs](core/cli_geniusctl.md)
    - geniusrise.cli.boltctl: [apidocs](core/cli_boltctl.md)
    - geniusrise.cli.spoutctl: [apidocs](core/cli_spoutctl.md)
    - geniusrise.cli.schema: [apidocs](core/cli_schema.md)
    - geniusrise.cli.discover: [apidocs](core/cli_discover.md)
- geniusrise.core:
    - geniusrise.core.bolt: [apidocs](core/core_bolt.md)
    - geniusrise.core.spout: [apidocs](core/core_spout.md)
    - geniusrise.core.data:
        - geniusrise.core.data.batch_input: [apidocs](core/core_data_batch_input.md)
        - geniusrise.core.data.batch_output: [apidocs](core/core_data_batch_output.md)
        - geniusrise.core.data.input: [apidocs](core/core_data_input.md)
        - geniusrise.core.data.output: [apidocs](core/core_data_output.md)
        - geniusrise.core.data.streaming_input: [apidocs](core/core_data_streaming_input.md)
        - geniusrise.core.data.streaming_output: [apidocs](core/core_data_streaming_output.md)
    - geniusrise.core.state:
        - geniusrise.core.state.base: [apidocs](core/core_state_base.md)
        - geniusrise.core.state.dynamo: [apidocs](core/core_state_dynamo.md)
        - geniusrise.core.state.memory: [apidocs](core/core_state_memory.md)
        - geniusrise.core.state.postgres: [apidocs](core/core_state_postgres.md)
        - geniusrise.core.state.redis: [apidocs](core/core_state_redis.md)
    - geniusrise.core.task:
        - geniusrise.core.task.base: [apidocs](core/core_task_base.md)
        - geniusrise.core.task.ecs: [apidocs](core/core_task_ecs.md)
        - geniusrise.core.task.k8s: [apidocs](core/core_task_k8s.md)
