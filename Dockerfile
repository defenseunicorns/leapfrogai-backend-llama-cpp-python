ARG ARCH=amd64

FROM ghcr.io/defenseunicorns/leapfrogai/python:3.11-dev-${ARCH} as builder

WORKDIR /leapfrogai

COPY requirements.txt .

RUN pip install -r requirements.txt --user
RUN pip install wget --user

USER root
RUN mkdir -p .model/ && \
    wget https://huggingface.co/TheBloke/OpenHermes-2.5-Mistral-7B-GGUF/resolve/main/openhermes-2.5-mistral-7b.Q4_K_M.gguf && \
    mv openhermes-2.5-mistral-7b.Q4_K_M.gguf .model/model.gguf

FROM ghcr.io/defenseunicorns/leapfrogai/python:3.11-${ARCH}

WORKDIR /leapfrogai

COPY --from=builder /home/nonroot/.local/lib/python3.11/site-packages /home/nonroot/.local/lib/python3.11/site-packages
COPY --from=builder /home/nonroot/.local/bin/leapfrogai /home/nonroot/.local/bin/leapfrogai
COPY --from=builder /leapfrogai/.model/ /leapfrogai/.model/

COPY main.py .
COPY config.yaml .

EXPOSE 50051:50051

ENTRYPOINT ["/home/nonroot/.local/bin/leapfrogai", "--app-dir=.", "main:Model"]