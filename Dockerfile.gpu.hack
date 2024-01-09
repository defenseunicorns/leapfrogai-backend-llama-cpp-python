ARG ARCH=amd64
ARG MODEL_URL=https://huggingface.co/TheBloke/SynthIA-7B-v2.0-GGUF/resolve/main/synthia-7b-v2.0.Q4_K_M.gguf

FROM nvidia/cuda:12.3.1-devel-ubuntu22.04 as builder

ENV DEBIAN_FRONTEND=noninteractive
ENV LLAMA_CUBLAS=1

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

# TODO: Change this back to using MODEL_URL before merge
COPY .model/ .model/

FROM ghcr.io/defenseunicorns/leapfrogai/python:3.11-${ARCH}

ENV CUDA_DOCKER_ARCH=all
ENV GPU_ENABLED=true
ENV PATH="/leapfrogai/.venv/bin:$PATH"
ENV LD_LIBRARY_PATH="/leapfrogai/.venv/lib64:$LD_LIBRARY_PATH"

WORKDIR /leapfrogai

COPY --from=builder /leapfrogai/.venv/ /leapfrogai/.venv/
COPY --from=builder /leapfrogai/.model/ /leapfrogai/.model/

COPY main.py .
COPY config.yaml .

EXPOSE 50051:50051

ENTRYPOINT ["leapfrogai", "--app-dir=.", "main:Model"]