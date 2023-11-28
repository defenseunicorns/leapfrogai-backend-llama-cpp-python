import copy
import sys
from pathlib import Path
from typing import Iterator

path_root = Path(__file__).parents[2]
sys.path.append(str(path_root))
print(sys.path)
import grpc
import leapfrogai

system_prompt = """<|im_start|>system
You are a helpful chat assistant.<|im_end|>
<|im_start|>user
Write an example Hello, World! server in Go.<|im_end|>
<|im_start|>assistant
"""

messages = {}


def run():
    # Set up a channel to the server
    with grpc.insecure_channel("localhost:50051") as channel:
        # Instantiate a stub (client)

        stub = leapfrogai.ChatCompletionStreamServiceStub(channel)

        # Create a request
        request = leapfrogai.ChatCompletionRequest(
            chat_items=[
                leapfrogai.ChatItem(
                    role=leapfrogai.ChatRole.SYSTEM,
                    content="You are helpful chat assistant. If you don't know the answer to something, say you don't know, do not make things up.",
                ),
                leapfrogai.ChatItem(
                    role=leapfrogai.ChatRole.USER,
                    content="How do I write an example server using Express and Node.js?",
                ),
            ],
            max_new_tokens=2048,
            temperature=0.5,
            n=1,
        )

        # Make a call to the server and get a response
        response: Iterator[leapfrogai.ChatCompletionResponse] = stub.ChatCompleteStream(
            request
        )

        for completion in response:
            print(completion.choices[0].chat_item.content, end="", flush=True)


if __name__ == "__main__":
    run()
