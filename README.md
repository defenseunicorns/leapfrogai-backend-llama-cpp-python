# LeapfrogAI llama-cpp-py Backend

## Getting Started

Inside a virtualenv:

```
pip install -r requirements.txt
leapfrogai main:Model
```

In another terminal, using the same virtualenv, run the tests:

```
python tests/test_completion.py
```

### GPU Inferencing

For GPU inferencing, the environment variable `GPU_ENABLED` must be set to "True" via Zarf, Docker or CLI. Additionally, if using Docker, Docker must already have access to your GPUs via `nvidia-container-runtime` and `nvidia-container-toolkit`.

## TODO:

- [ ] Configurable model for Dockerfile / repeatable steps
- [ ] Batched inference support (https://github.com/abetlen/llama-cpp-python/pull/951) for concurrent requests
