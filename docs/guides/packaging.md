# Packaging

## Overview

Geniusrise uses docker for packaging and delivering modules.

## Capabilities

- **Docker Image Creation**: Create Docker images with custom base images, working directories, and local directories.
- **Package Installation**: Install both OS-level and Python packages during the Docker image creation.
- **Environment Variables**: Set environment variables in the Docker container.
- **Multi-Repository Support**: Upload Docker images to multiple types of container repositories.
- **Authentication**: Supports various authentication methods for different container repositories.

## Command-Line Interface

### Syntax

```bash
genius docker package <image_name> <repository> [options]
```

### Parameters

- `<image_name>`: The name of the Docker image to build and upload.
- `<repository>`: The container repository to upload to (e.g., "ECR", "DockerHub", "Quay", "ACR", "GCR").

### Options

- `--auth`: Authentication credentials as a JSON string. Default is an empty JSON object.
- `--base_image`: The base image to use for the Docker container. Default is "nvidia/cuda:12.2.0-runtime-ubuntu20.04".
- `--workdir`: The working directory in the Docker container. Default is "/app".
- `--local_dir`: The local directory to copy into the Docker container. Default is ".".
- `--packages`: List of Python packages to install in the Docker container. Default is an empty list.
- `--os_packages`: List of OS packages to install in the Docker container. Default is an empty list.
- `--env_vars`: Environment variables to set in the Docker container. Default is an empty dictionary.

## Authentication Details

- **ECR**: `{"aws_region": "ap-south-1", "aws_secret_access_key": "aws_key", "aws_access_key_id": "aws_secret"}`
- **DockerHub**: `{"dockerhub_username": "username", "dockerhub_password": "password"}`
- **ACR**: `{"acr_username": "username", "acr_password": "password", "acr_login_server": "login_server"}`
- **GCR**: `{"gcr_key_file_path": "/path/to/keyfile.json", "gcr_repository": "repository"}`
- **Quay**: `{"quay_username": "username", "quay_password": "password"}`

## Examples

### Uploading to ECR (Amazon Elastic Container Registry)

```bash
genius docker package geniusrise ecr --auth '{"aws_region": "ap-south-1"}'
```

### Uploading to DockerHub

```bash
genius docker package geniusrise dockerhub --auth '{"dockerhub_username": "username", "dockerhub_password": "password"}'
```

### Uploading to ACR (Azure Container Registry)

```bash
genius docker package geniusrise acr --auth '{"acr_username": "username", "acr_password": "password", "acr_login_server": "login_server"}'
```

### Uploading to GCR (Google Container Registry)

```bash
genius docker package geniusrise gcr --auth '{"gcr_key_file_path": "/path/to/keyfile.json", "gcr_repository": "repository"}'
```

### Uploading to Quay

```bash
genius docker package geniusrise quay --auth '{"quay_username": "username", "quay_password": "password"}'
```

### Uploading with Custom Packages and OS Packages

```bash
genius docker package geniusrise dockerhub \
    --packages geniusrise-listeners geniusrise-databases geniusrise-huggingface geniusrise-openai \
    --os_packages libmysqlclient-dev libldap2-dev libsasl2-dev libssl-dev
```

### Uploading with Environment Variables

```bash
genius docker package geniusrise dockerhub --env_vars '{"API_KEY": "123456", "ENV": "production"}'
```

## Complex Examples

### 1. Uploading to ECR with Custom Base Image and Packages

This example demonstrates how to upload a Docker image to ECR with a custom base image and additional Python packages.

```bash
genius docker package my_custom_image ecr \
    --auth '{"aws_region": "us-west-2", "aws_secret_access_key": "aws_key", "aws_access_key_id": "aws_secret"}' \
    --base_image "python:3.9-slim" \
    --packages "numpy pandas scikit-learn" \
    --os_packages "gcc g++"
```

### 2. Uploading to DockerHub with Environment Variables and Working Directory

This example shows how to upload a Docker image to DockerHub with custom environment variables and a specific working directory.

```bash
genius docker package my_app dockerhub \
    --auth '{"dockerhub_username": "username", "dockerhub_password": "password"}' \
    --env_vars '{"DEBUG": "True", "SECRET_KEY": "mysecret"}' \
    --workdir "/my_app"
```

### 3. Uploading to ACR with Multiple Local Directories

In this example, we upload a Docker image to Azure Container Registry (ACR) and specify multiple local directories to be copied into the Docker container.

```bash
# First, create a Dockerfile that copies multiple directories
# Then use the following command
genius docker package multi_dir_app acr \
    --auth '{"acr_username": "username", "acr_password": "password", "acr_login_server": "login_server"}' \
    --local_dir "./app ./config"
```

### 4. Uploading to GCR with Custom Base Image, Packages, and OS Packages

This example demonstrates how to upload a Docker image to Google Container Registry (GCR) with a custom base image, Python packages, and OS packages.

```bash
genius docker package my_ml_model gcr \
    --auth '{"gcr_key_file_path": "/path/to/keyfile.json", "gcr_repository": "repository"}' \
    --base_image "tensorflow/tensorflow:latest-gpu" \
    --packages "scipy keras" \
    --os_packages "libsm6 libxext6 libxrender-dev"
```

### 5. Uploading to Quay with All Customizations

This example shows how to upload a Docker image to Quay with all available customizations like base image, working directory, local directory, Python packages, OS packages, and environment variables.

```bash
genius docker package full_custom quay \
    --auth '{"quay_username": "username", "quay_password": "password"}' \
    --base_image "alpine:latest" \
    --workdir "/custom_app" \
    --local_dir "./src" \
    --packages "flask gunicorn" \
    --os_packages "bash curl" \
    --env_vars '{"FLASK_ENV": "production", "PORT": "8000"}'
```
