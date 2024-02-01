ARG ARCH=amd64

FROM nvidia/cuda:12.2.2-devel-ubuntu22.04 as builder

ENV DEBIAN_FRONTEND=noninteractive
ENV LLAMA_CUBLAS=1

# grab necesary python dependencies
RUN apt-get -y update \
    && apt-get install -y software-properties-common \
    && apt-get -y update \
    && add-apt-repository universe \ 
    && add-apt-repository ppa:deadsnakes/ppa
RUN apt-get -y update
RUN apt-get -y install python3.11-full git wget

WORKDIR /leapfrogai

# create virtual environment for easy portability and minimal size
RUN python3.11 -m venv .venv
ENV PATH="/leapfrogai/.venv/bin:$PATH"

# llama.cpp requires compililation within nvidia/cuda capable image
COPY requirements.txt .
RUN CMAKE_ARGS="-DLLAMA_CUBLAS=on" pip install -r requirements.txt -v

# ARG can be changed during build command
ARG MODEL_URL=https://huggingface.co/TheBloke/SynthIA-7B-v2.0-GGUF/resolve/main/synthia-7b-v2.0.Q4_K_M.gguf
RUN mkdir -p .model/ && wget ${MODEL_URL} -O .model/model.gguf

# hardened and slim python image
FROM ghcr.io/defenseunicorns/leapfrogai/python:3.11-${ARCH}

# point to all CUDA dependencies that must be brought into python image
ENV CUDA_DOCKER_ARCH=all
ENV GPU_ENABLED=true
ENV PATH="/usr/local/cuda/bin${PATH:+:${PATH}}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
ENV CUDAToolkit_ROOT="/usr/local/cuda/"
ENV CUDACXX="/usr/local/cuda/bin/nvcc"
ENV PATH="/leapfrogai/.venv/bin:$PATH"

WORKDIR /leapfrogai

COPY --from=builder /leapfrogai/.venv/ /leapfrogai/.venv/
COPY --from=builder /leapfrogai/.model/ /leapfrogai/.model/
COPY --from=builder /usr/local/cuda/ /usr/local/cuda/

COPY main.py .
COPY config.yaml .

EXPOSE 50051:50051

ENTRYPOINT ["leapfrogai", "--app-dir=.", "main:Model"]
