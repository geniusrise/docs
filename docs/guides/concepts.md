# Concepts

## Need

---

The landscape of machine learning and data processing has been rapidly evolving. While there are numerous solutions available for MLOps and DAG orchestration, most of them cater primarily to data engineering and data science teams. However, the rise of Large Language Models (LLMs) is reshaping this landscape, necessitating a more inclusive approach to MLOps.

LLMs have democratized the use of machine learning models, enabling a broader spectrum of users within an organization to engage with them. This means that even organizations without a traditional data science data management or model management functions are now venturing into this domain.

This shift brings forth several challenges:

1. **Infrastructure Complexity**: The world of MLOps is vast, with a plethora of options available for different use cases. Organizations often grapple with questions like:
    - Which infrastructure is best suited for their needs?
    - How can they efficiently reuse their existing infrastructure?
    - How can they ensure scalability and performance while managing costs?

2. **Diverse Competence Levels**: As LLM workflows become more prevalent, their volume is set to surpass that of traditional ML workflows in many organizations. This surge means that individuals without a formal engineering background or core ML expertise will be involved in the MLOps process. Ensuring that these individuals can contribute effectively without compromising the quality or integrity of the workflows is crucial.

3. **Standardization and Productionization**: While many aspects of building LLM workflows can be managed without deep engineering expertise, there's a critical need for standardization. Engineers play a pivotal role in defining the processes for productionizing these workflows. Without standardized practices:
    - How can organizations ensure consistency across workflows?
    - How can they maintain the reliability and robustness of deployed models?
    - How can they ensure that best practices are adhered to, regardless of who is building or deploying the workflow?

The advent of LLMs underscores the need for an MLOps framework that caters to a diverse audience. Such a framework should be flexible enough to accommodate the varied infrastructure needs of organizations, inclusive enough to empower contributors regardless of their technical expertise, and robust enough to ensure standardized, reliable workflows.

## Introduction

---

The Geniusrise framework is built around loosely-coupled modules acting as a cohesive adhesive between distinct, modular components, much like how one would piece together Lego blocks. This design approach not only promotes flexibility but also ensures that each module or "Lego block" remains sufficiently independent. Such independence is crucial for diverse teams, each with its own unique infrastructure and requirements, to seamlessly build and manage their respective components.

Geniusrise comes with a sizable set of plugins which implement various features and integrations. The independence and modularity of the design enable sharing of these building blocks in the community.

## Concepts

---

1. **Task**: At its core, a task represents a discrete unit of work within the Geniusrise framework. Think of it as a singular action or operation that the system needs to execute. A task further manifests itself into a Bolt or a Spout as stated below.

2. **Components of a Task**: Each task is equipped with four components:
    1. **State Manager**: This component is responsible for continuously monitoring and managing the task's state, ensuring that it progresses smoothly from initiation to completion and to report errors and ship logs into a central location.
    2. **Data Manager**: As the name suggests, the Data Manager oversees the input and output data associated with a task, ensuring data integrity and efficient data flow. It also ensures data sanity follows partition semantics and isolation.
    3. **Model Manager**: In the realm of machine learning, model versioning and management are paramount. The Model Manager serves as a GitOps tool for ML models, ensuring that they are versioned, tracked, and managed effectively.
    4. **Runner**: These are wrappers for executing a task on various platforms. Depending on the platform, the runner ensures that the task is executed seamlessly.

3. **Task Classification**: Tasks within the Geniusrise framework can be broadly classified into two categories:
    - **Spout**: If a task's primary function is to ingest or bring in data, it's termed as a 'spout'.
    - **Bolt**: For tasks that don't primarily ingest data but perform other operations, they are termed 'bolts'.

The beauty of the Geniusrise framework lies in its adaptability. Developers can script their workflow components once and have the freedom to deploy them across various platforms. To facilitate this, Geniusrise offers:

1. **Runners for Task Execution**: Geniusrise is equipped with a diverse set of runners, each tailored for different platforms, ensuring that tasks can be executed almost anywhere:
    1. On your **local machine** for quick testing and development.
    2. Within **Docker containers** for isolated, reproducible environments.
    3. On **Kubernetes** clusters for scalable, cloud-native deployments.
    4. Using **Apache Airflow** for complex workflow orchestration.
    5. On **AWS ECS** for containerized application management.
    6. With **AWS Batch** for efficient batch computing workloads.

2. **Library Wrappers**: To ensure that tasks can interface with a variety of frameworks, Geniusrise provides integrations with:
    1. **Jupyter/ipython** for interactive computing.
    2. **Apache PySpark** for large-scale data processing.
    3. **Apache PyFlink** for stream and batch processing.
    4. **Apache Beam** for unified stream and batch data processing.
    5. **Apache Storm** for real-time computation.

3. **Genius hub** - Where developers can share and sell their components. Coming soon [geniusrise.com](https://geniusrise.com/).

The framework aims to support multiple languages:

1. Python
2. Scala / JVM (WIP)
3. Golang (WIP)

This document delves into the core components and concepts that make up the Geniusrise framework.

## Tradeoffs

Because of the very loose coupling of the components, though the framework can be used to build very complex networks with independently running nodes, it provides limited orchestration capability, like synchronous pipelines. An external orchestrator like airflow can be used in such cases to orchestrate geniusrise components.
