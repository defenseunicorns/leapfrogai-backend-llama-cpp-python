# LeapfrogAI llama-cpp-py Backend

## Getting Started

You can start playing with this backend locally by running the model directly on your machine, or through a Docker container. We show instructures for both approaches below.

Inside a virtualenv:
```
pip install -r requirements.txt
cp config.example.yaml config.yaml
mkdir .model
wget -O .model/model.gguf https://huggingface.co/TheBloke/OpenHermes-2.5-Mistral-7B-GGUF/resolve/main/openhermes-2.5-mistral-7b.Q4_K_M.gguf
leapfrogai main:Model
```



Using a docker container (change {ARCH} for either amd64 or arm64):
```
docker run -p 50051:50051 ghcr.io/defenseunicorns/leapfrogai/llama-cpp-py:dev-{ARCH}
```

### Validate Deployment
In another terminal, using the same virtualenv, run the tests:

```
python tests/test_completion.py
```

## TODO:
- [] Configurable model for Dockerfile / repeatable steps
- [] Batched inference support (https://github.com/abetlen/llama-cpp-python/pull/951) for concurrent requests