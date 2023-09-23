# Deployment

## Introduction

This guide provides comprehensive instructions on how to deploy and manage resources in a Kubernetes cluster using the Geniusrise platform. The guide covers the following functionalities:

- Connecting to a Kubernetes cluster
- Managing Pods
- Managing Deployments
- Managing Services
- Managing Jobs
- Managing Cron jobs

## Prerequisites

- A working Kubernetes cluster
- Kubeconfig file for cluster access
- Python 3.x installed
- Geniusrise CLI installed

## Connecting to a Kubernetes Cluster

Before performing any operations, you need to connect to your Kubernetes cluster. You can do this in two ways:

1. Using a kubeconfig file and context name
2. Using an API key and API host

### Using Kubeconfig and Context Name

```bash
genius k8s <command> --kube_config_path /path/to/kubeconfig.yaml --context_name my-context
```

### Using API Key and API Host

```bash
genius k8s <command> --api_key my-api-key --api_host https://api.k8s.my-cluster.com --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

## Managing Pods

### Checking Pod Status

To get the status of a specific pod:

```bash
genius k8s status my-pod-name --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

### Listing All Pods

To list all the pods in the current namespace:

```bash
genius k8s show --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

### Describing a Pod

To get detailed information about a specific pod:

```bash
genius k8s describe my-pod-name --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

### Fetching Pod Logs

To get the logs of a specific pod:

```bash
genius k8s logs my-pod-name --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

## Managing Deployments

### Creating a New Deployment

To create a new deployment:

```bash
genius deployment create --name my-deployment --image my-image --command "echo hello" --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

### Scaling a Deployment

To scale a deployment:

```bash
genius deployment scale --name my-deployment --replicas 3 --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

### Listing All Deployments

To list all deployments:

```bash
genius deployment show
```

### Describing a Deployment

To describe a specific deployment:

```bash
genius deployment describe my-deployment --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

### Deleting a Deployment

To delete a deployment:

```bash
genius deployment delete my-deployment --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

### Checking Deployment Status

To check the status of a deployment:

```bash
genius deployment status my-deployment --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

## Advanced Features

### Environment Variables

You can pass environment variables to your pods and deployments like so:

```bash
genius deployment create --name my-deployment --image my-image --command "echo hello" --env_vars '{"MY_VAR": "value"}' --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

### Resource Requirements

You can specify resource requirements for your pods and deployments:

```bash
genius deployment create --name my-deployment --image my-image --command "echo hello" --cpu "100m" --memory "256Mi" --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

### GPU Support

To allocate GPUs to your pods:

```bash
genius deployment create --name my-deployment --image my-image --command "echo hello" --gpu "1" --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

## Managing Services

### Creating a New Service

To create a new service:

```bash
genius service create --name example-service --image example-image --command "echo hello" --port 8080 --target_port 8080 --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

### Deleting a Service

To delete a service:

```bash
genius service delete --name example-service --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

### Describing a Service

To describe a specific service:

```bash
genius service describe --name example-service --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

### Listing All Services

To list all services:

```bash
genius service show --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

## Managing Jobs

### Creating a New Job

To create a new job:

```bash
genius job create --name example-job --image example-image --command "echo hello" --cpu "100m" --memory "256Mi" --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

### Deleting a Job

To delete a job:

```bash
genius job delete --name example-job --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

### Checking Job Status

To check the status of a job:

```bash
genius job status --name example-job --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

## Managing Cron Jobs

### Creating a New Cron Job

To create a new cron job, you can use the `create_cronjob` sub-command. You'll need to specify the name, Docker image, command to run, and the cron schedule.

```bash
genius cronjob create_cronjob --name example-cronjob --image example-image --command "echo hello" --schedule "*/5 * * * *" --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

#### Additional Options

- `--env_vars`: To set environment variables, pass them as a JSON string.
- `--cpu`, `--memory`, `--storage`, `--gpu`: To set resource requirements.

### Deleting a Cron Job

To delete a cron job, use the `delete_cronjob` sub-command and specify the name of the cron job.

```bash
genius cronjob delete_cronjob --name example-cronjob --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

### Checking Cron Job Status

To check the status of a cron job, use the `get_cronjob_status` sub-command and specify the name of the cron job.

```bash
genius cronjob get_cronjob_status --name example-cronjob --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

### Advanced Features for Cron Jobs

#### Environment Variables

You can pass environment variables to your cron jobs like so:

```bash
genius cronjob create_cronjob --name example-cronjob --image example-image --command "echo hello" --schedule "*/5 * * * *" --env_vars '{"MY_VAR": "value"}' --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

#### Resource Requirements

You can specify resource requirements for your cron jobs:

```bash
genius cronjob create_cronjob --name example-cronjob --image example-image --command "echo hello" --schedule "*/5 * * * *" --cpu "100m" --memory "256Mi" --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```

#### GPU Support

To allocate GPUs to your cron jobs:

```bash
genius cronjob create_cronjob --name example-cronjob --image example-image --command "echo hello" --schedule "*/5 * * * *" --gpu "1" --namespace geniusrise \
  --context_name arn:aws:eks:us-east-1:genius-dev:cluster/geniusrise-dev
```
