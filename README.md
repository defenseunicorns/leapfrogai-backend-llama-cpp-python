# LeapfrogAI llama-cpp-python Backend

## Description

A LeapfrogAI API-compatible [llama-cpp-python](https://github.com/abetlen/llama-cpp-python) wrapper for quantized and un-quantized model inferencing across CPU and GPU infrastructures.

## Usage

See [instructions](#instructions) to get the backend up and running. Then, use the [LeapfrogAI API server](https://github.com/defenseunicorns/leapfrogai-api) to interact with the backend.

## Instructions

The instructions in this section assume the following:

1. Properly installed and configured Python 3.11.x, to include its development tools
2. The LeapfrogAI API server is deployed and running

<details>
<summary><b>GPU Variation</b></summary>
<br/>
The following are additional assumptions for GPU inferencing:

3. You have properly installed one or more NVIDIA GPUs and GPU drivers
4. You have properly installed and configured the [cuda-toolkit](https://developer.nvidia.com/cuda-toolkit) and [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html)
</details>

### Model Selection

The default model that comes with this backend in this repository's officially released images is a [4-bit quantization of the Synthia-7b model](https://huggingface.co/TheBloke/SynthIA-7B-v2.0-GGUF).

Other models can be loaded into this backend by modifying or supplying the [model_download.py](./scripts/model_download.py) arguments during image creation or Makefile command execution. The arguments must point to a single quantized model file, else you will need to use the [llama.cpp](https://github.com/ggerganov/llama.cpp) converter on an un-quantized model. Please see the Dockerfile or Makefile for further details.

### Run Locally

<details>
<summary><b>GPU Variation</b></summary>
<br/>
The following additional variables must be exported for local GPU inferencing:

```bash
# install with GPU compilation and deps
make requirements-dev
# OR
make requirements-gpu

# enable GPU switch
export GPU_ENABLED=true
```

</details>
<br/>

```bash
# Setup Virtual Environment
make create-venv
source .venv/bin/activate
make requirements-dev

# Clone Model
# Supply a REPO_ID, FILENAME and REVISION if a different model is desired
make fetch-model

# Start Model Backend
python main.py
```

### Run in Docker

#### Local Image Build and Run

<details>
<summary><b>GPU Variation</b></summary>
<br/>
The following additional variables must be exported for local GPU inferencing:

```bash
# Supply a REPO_ID, FILENAME and REVISION if a different model is desired
make docker-build-gpu
# without GPU
make docker-run-gpu
```

</details>
<br/>

For local image building and running.

```bash
# Supply a REPO_ID, FILENAME and REVISION if a different model is desired
make docker-build
# without GPU, CPU-only
make docker-run
```

#### Remote Image Build and Run

For pulling a tagged image from the main release repository.

Where `<IMAGE_TAG>` is the released packages found [here](https://github.com/orgs/defenseunicorns/packages/container/package/leapfrogai%2Fllama-cpp-python).

```bash
docker build -t ghcr.io/defenseunicorns/leapfrogai/llama-cpp-python:<IMAGE_TAG> .
docker run -p 50051:50051 -d --name llama-cpp-python ghcr.io/defenseunicorns/leapfrogai/llama-cpp-python:<IMAGE_TAG>
```

<details>
<summary><b>GPU Variation</b></summary>
<br/>
The following changes are required to pull and run the GPU image:

```bash
docker build -t ghcr.io/defenseunicorns/leapfrogai/llama-cpp-python-gpu:<IMAGE_TAG> .
docker run --gpus device=0 -e GPU_ENABLED=true -p 50051:50051 -d --name llama-cpp-python ghcr.io/defenseunicorns/leapfrogai/llama-cpp-python:<IMAGE_TAG>
```

</details>
<br/>

### llama-cpp-python Specific Packaging

llama-cpp-python requires access to host system GPU drivers in order to operate when compiled specifically for GPU inferencing. Even if no layers are offloaded to the GPU at runtime, llama-cpp-python will throw an unrecoverable exception. That being said, a separate `Dockerfile.gpu` and Zarf package instruction are maintained.

For Zarf package creation, the following flag must be added when a user requires the GPU Docker image: `--set IMAGE_REPOSITORY=ghcr.io/defenseunicorns/leapfrogai/llama-cpp-python-gpu`
