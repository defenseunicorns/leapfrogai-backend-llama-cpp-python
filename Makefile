MODEL_URL ?= https://huggingface.co/TheBloke/SynthIA-7B-v2.0-GGUF/resolve/main/synthia-7b-v2.0.Q4_K_M.gguf

.PHONY: all

create-venv:
	python -m venv .venv

activate-venv:
	source .venv/bin/activate

fetch-model:
	mkdir -p .model/
	wget ${MODEL_URL}
	mv *.gguf .model/model.gguf	

requirements-dev:
	CMAKE_ARGS="-DLLAMA_CUBLAS=on" python -m pip install -r requirements-dev.txt
	
requirements:
	CMAKE_ARGS="-DLLAMA_CUBLAS=on" pip-sync requirements.txt requirements-dev.txt

build-requirements:
	pip-compile -o requirements.txt pyproject.toml

build-requirements-dev:
	pip-compile --extra dev -o requirements-dev.txt pyproject.toml

test:
	pytest **/*.py

dev:
	leapfrogai main:Model
