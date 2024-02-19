# Concepts

The Geniusrise framework is built around loosely-coupled modules acting as a cohesive adhesive between distinct, modular components, much like how one would piece together Lego blocks. This design approach not only promotes flexibility but also ensures that each module or "Lego block" remains sufficiently independent. Such independence is crucial for diverse teams, each with its own unique infrastructure and requirements, to seamlessly build and manage their respective components.

Geniusrise comes with a sizable set of plugins which implement various features and integrations. The independence and modularity of the design enable sharing of these building blocks in the community.

## Concepts

---

1. **Task**: At its core, a task represents a discrete unit of work within the Geniusrise framework. Think of it as a singular action or operation that the system needs to execute. A task further manifests itself into a Bolt or a Spout as stated below.

2. **Components of a Task**: Each task is equipped with four components:
    1. **State Manager**: This component is responsible for continuously monitoring and managing the task's state, ensuring that it progresses smoothly from initiation to completion and to report errors and ship logs into a central location.
    2. **Data Manager**: As the name suggests, the Data Manager oversees the input and output data associated with a task, ensuring data integrity and efficient data flow. It also ensures data sanity follows partition semantics and isolation.
    3. **Runner**: These are wrappers for executing a task on various platforms. Depending on the platform, the runner ensures that the task is executed seamlessly.

3. **Task Classification**: Tasks within the Geniusrise framework can be broadly classified into two categories:
    - **Spout**: If a task's primary function is to ingest or bring in data, it's termed as a 'spout'.
    - **Bolt**: For tasks that don't primarily ingest data but perform other operations, they are termed 'bolts'.

The beauty of the Geniusrise framework lies in its adaptability. Developers can script their workflow components once and have the freedom to deploy them across various platforms. To facilitate this, Geniusrise offers:

1. **Runners for Task Execution**: Geniusrise is equipped with a diverse set of runners, each tailored for different platforms, ensuring that tasks can be executed almost anywhere:
    1. On your **local machine** for quick testing and development.
    2. Within **Docker containers** for isolated, reproducible environments.
    3. On **Kubernetes** clusters for scalable, cloud-native deployments.
    4. Using **Apache Airflow** for complex workflow orchestration. (Coming Soon).
    5. On **AWS ECS** for containerized application management. (Coming Soon).
    6. With **AWS Batch** for efficient batch computing workloads. (Coming Soon).
    7. With **Docker Swarm** clusters as an alternative orchestrator to kubernetes. (Coming Soon).

This document delves into the core components and concepts that make up the Geniusrise framework.

## Tradeoffs

Because of the very loose coupling of the components, though the framework can be used to build very complex networks with independently running nodes, it provides limited orchestration capability, like synchronous pipelines. An external orchestrator like airflow can be used in such cases to orchestrate geniusrise components.
