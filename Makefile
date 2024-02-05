MODEL_URL ?= https://huggingface.co/TheBloke/SynthIA-7B-v2.0-GGUF/resolve/main/synthia-7b-v2.0.Q4_K_M.gguf
VERSION ?= $(shell git fetch --tags && git tag -l "*.*.*" | sort -V | tail -n 1 | sed -e 's/^v//')
ARCH ?= $(shell uname -m | sed s/aarch64/arm64/ | sed s/x86_64/amd64/)

.PHONY: all

create-venv:
	python -m venv .venv

activate-venv:
	source .venv/bin/activate

fetch-model:
	python scripts/model_download.py
	mv .model/*.gguf .model/model.gguf
	
requirements:
	pip install -r requirements.txt

requirements-dev:
	CMAKE_ARGS="-DLLAMA_CUBLAS=on" pip install -r requirements-dev.txt

requirements-gpu:
	CMAKE_ARGS="-DLLAMA_CUBLAS=on" pip install -r requirements-gpu.txt

build-requirements:
	pip-compile -o requirements.txt pyproject.toml

build-requirements-dev:
	pip-compile --extra dev -o requirements-dev.txt pyproject.toml

build-requirements-gpu:
	pip-compile --extra gpu -o requirements-gpu.txt pyproject.toml

test:
	pytest **/*.py

dev:
	leapfrogai main:Model

docker-build:
	if ! [ -f config.yaml ]; then cp config.example.yaml config.yaml; fi
	docker build -t ghcr.io/defenseunicorns/leapfrogai/llama-cpp-python:${VERSION}-${ARCH} . --build-arg ARCH=${ARCH}

docker-build-gpu:
	if ! [ -f config.yaml ]; then cp config.example.yaml config.yaml; fi
	docker build -f Dockerfile.gpu -t ghcr.io/defenseunicorns/leapfrogai/llama-cpp-python-gpu:${VERSION}-${ARCH} . --build-arg ARCH=${ARCH}

docker-run:
	docker run -d -p 50051:50051 ghcr.io/defenseunicorns/leapfrogai/llama-cpp-python:${VERSION}-${ARCH}

docker-run-gpu:
	docker run --gpus device=0 -e GPU_ENABLED=true -d -p 50051:50051 ghcr.io/defenseunicorns/leapfrogai/llama-cpp-python-gpu:${VERSION}-${ARCH}

docker-push:
	docker push ghcr.io/defenseunicorns/leapfrogai/llama-cpp-python:${VERSION}-${ARCH}

docker-push-gpu:
	docker push ghcr.io/defenseunicorns/leapfrogai/llama-cpp-python-gpu:${VERSION}-${ARCH}