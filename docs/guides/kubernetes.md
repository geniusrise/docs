# Kubernetes Runner

## Overview

This runner module enables running spouts or bolts on Kubernetes. It provides the ability to:

1. create
2. delete
3. scale
4. describe

various Kubernetes resources like

1. Pods
2. Deployments
3. Services

## Command-Line Interface

The following commands are available:

1. `create`: Create a Kubernetes resource.
2. `delete`: Delete a Kubernetes resource.
3. `status`: Get the status of a Kubernetes resource.
4. `logs`: Get logs of a Kubernetes resource.
5. `pod`: Describe a Kubernetes pod.
6. `pods`: List all pods.
7. `service`: Describe a Kubernetes service.
8. `services`: List all services.
9. `deployment`: Describe a Kubernetes deployment.
10. `deployments`: List all deployments.
11. `scale`: Scale a Kubernetes deployment.

### Common Arguments

These arguments are common to all commands:

- `--kube_config_path`: Path to the kubeconfig file.
- `--cluster_name`: Name of the Kubernetes cluster.
- `--context_name`: Name of the kubeconfig context.
- `--namespace`: Kubernetes namespace (default is "default").
- `--labels`: Labels for Kubernetes resources, as a JSON string.
- `--annotations`: Annotations for Kubernetes resources, as a JSON string.
- `--api_key`: API key for Kubernetes cluster.
- `--api_host`: API host for Kubernetes cluster.
- `--verify_ssl`: Whether to verify SSL certificates (default is True).
- `--ssl_ca_cert`: Path to the SSL CA certificate.

### `create_resource`

Create a Kubernetes resource.

- `name`: Name of the resource.
- `image`: Docker image for the resource.
- `command`: Command to run in the container.
- `--registry_creds`: Credentials for Docker registry, as a JSON string.
- `--is_service`: Whether this is a service (default is False).
- `--replicas`: Number of replicas (default is 1).
- `--port`: Service port (default is 80).
- `--target_port`: Container target port (default is 8080).
- `--env_vars`: Environment variables, as a JSON string.

Example:

```bash
python script.py create_resource my_resource nginx "nginx -g 'daemon off;'" --replicas=3
```

### `delete_resource`

Delete a Kubernetes resource.

- `name`: Name of the resource.
- `--is_service`: Whether this is a service (default is False).

Example:

```bash
python script.py delete_resource my_resource
```

### `get_status`

Get the status of a Kubernetes resource.

- `name`: Name of the resource.

Example:

```bash
python script.py get_status my_resource
```

### `get_logs`

Get logs of a Kubernetes resource.

- `name`: Name of the resource.
- `--tail_lines`: Number of lines to tail (default is 10).

Example:

```bash
python script.py get_logs my_resource --tail_lines=20
```

### `scale`

Scale a Kubernetes deployment.

- `name`: Name of the deployment.
- `replicas`: Number of replicas.

Example:

```bash
python script.py scale my_resource 5
```

### `list_pods`, `list_services`, `list_deployments`

List all pods, services, or deployments.

Example:

```bash
python script.py list_pods
```

### `describe_pod`, `describe_service`, `describe_deployment`

Describe a pod, service, or deployment.

- `name`: Name of the resource.

Example:

```bash
python script.py describe_pod my_pod
```

## YAML Configuration

You can also use a YAML configuration file to specify the common arguments. The command-specific arguments will still come from the command line.

Example YAML:

```yaml
deploy:
  type: "k8s"
  args:
    kube_config_path: ""
    cluster_name: "geniusrise"
    context_name: "eks"
    namespace: "geniusrise_k8s_test"
    labels: { "tag1": "lol", "tag2": "lel" }
    annotations: {}
    api_key:
    api_host: localhost
    verify_ssl: true
    ssl_ca_cert:
```

To use the YAML configuration, you can read it in your Python script and pass the arguments to the `K8sResourceManager` methods.

Example:

```bash
python script.py --config=my_config.yaml create_resource my_resource nginx "nginx -g 'daemon off;'" --replicas=3
```

In this example, the `--config=my_config.yaml` would be used to read the common arguments from the YAML file, and the rest of the arguments would be taken from the command line.
