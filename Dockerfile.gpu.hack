FROM nvidia/cuda:12.3.1-devel-ubuntu22.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update \
    && apt-get install -y software-properties-common \
    && apt-get -y update \
    && add-apt-repository universe \ 
    && add-apt-repository ppa:deadsnakes/ppa
RUN apt-get -y update
RUN apt-get -y install python3.11-full git

WORKDIR /leapfrogai

RUN python3.11 -m venv .venv
ENV PATH="/leapfrogai/.venv/bin:$PATH"

COPY requirements-gpu.txt .
RUN CMAKE_ARGS="-DLLAMA_CUBLAS=on" pip install -r requirements-gpu.txt -v

COPY .model/ .model/
COPY main.py .
COPY config.yaml .

ENV CUDA_DOCKER_ARCH=all
ENV LLAMA_CUBLAS=1
ENV GPU_ENABLED=true

EXPOSE 50051:50051

ENTRYPOINT ["/bin/bash", "-c", "leapfrogai --app-dir=. main:Model"]