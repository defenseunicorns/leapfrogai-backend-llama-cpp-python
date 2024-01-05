# LeapfrogAI LLaMA-CPP-Python Backend

## Description

A LeapfrogAI API-compatible llama-cpp-python wrapper for quantized model inferencing.

## Usage

See [instructions](#instructions) to get the backend up and running. Then, use the [LeapfrogAI API server](https://github.com/defenseunicorns/leapfrogai-api) to interact with the backend.

## Instructions

The instructions in this section assume the following:

1. Properly installed and configured Python 3.11.x, to include its development tools
2. Installed `wget`
3. The LeapfrogAI API server is deployed and running
4. The `config.yaml` is created based on the `config-example.yaml`

### Run Locally

For cloning a model locally and running the development backend.

```bash
# Clone Model
make fetch-model

# Setup Python Virtual Environment
make create-venv
make activate-venv
make requirements-dev

# Start Model Backend
make dev
```

### Run in Docker

#### Local Image Build and Run

For local image building and running.

```bash
# Build the docker image
docker build -t ghcr.io/defenseunicorns/leapfrogai/llama-cpp-python:latest-cpu .

# Run the docker container
docker run -p 50051:50051 -v ./config.yaml:/leapfrogai/config.yaml ghcr.io/defenseunicorns/leapfrogai/llama-cpp-python:latest-cpu
```

#### Remote Image Build and Run

For pulling a tagged image from the main release repository.

Where `<IMAGE_TAG>` is the released packages found [here](https://github.com/orgs/defenseunicorns/packages/container/package/leapfrogai%2Fllama-cpp-python).

```bash
# Download and run remote image
docker run -p 50051:50051 -v ./config.yaml:/leapfrogai/config.yaml ghcr.io/defenseunicorns/leapfrogai/llama-cpp-python:<IMAGE_TAG>
```

### GPU Inferencing

The instructions in this section assume the following:

1. You have properly installed one or more NVIDIA GPUs and GPU drivers
2. You have properly installed and configured the [cuda-toolkit](https://developer.nvidia.com/cuda-toolkit) and [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html)

#### Run Locally

For cloning a model locally and running the development backend.

```bash
# Clone Model
make fetch-model

# Setup Python Virtual Environment
make create-venv
make activate-venv
make requirements-gpu

# enable GPU switch
export GPU_ENABLED=true

# Start Model Backend
make dev
```

#### Run in Docker

For local image building and running.

```bash
# Build GPU docker image
docker build -f Dockerfile.gpu.hack -t ghcr.io/defenseunicorns/leapfrogai/llama-cpp-python:latest-gpu .

# Run GPU docker container with GPU resource reservation
docker run --gpus all -p 50051:50051 -v ./config.yaml:/leapfrogai/config.yaml ghcr.io/defenseunicorns/leapfrogai/llama-cpp-python:latest-gpu
```

For pulling a tagged image from the main release repository.

Where `<IMAGE_TAG>` is the released packages found [here](https://github.com/orgs/defenseunicorns/packages/container/package/leapfrogai%2Fllama-cpp-python).

```bash
# Download and run remote GPU image
docker run -p 50051:50051 -v ./config.yaml:/leapfrogai/config.yaml ghcr.io/defenseunicorns/leapfrogai/llama-cpp-python:<IMAGE_TAG>
```
