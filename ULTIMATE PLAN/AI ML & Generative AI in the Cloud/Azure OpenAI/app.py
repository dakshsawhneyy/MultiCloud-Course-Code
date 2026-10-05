import os
from openai import AzureOpenAI

client = AzureOpenAI(
    azure_endpoint=os.environ["AZURE_OPENAI_ENDPOINT"],
    api_key=os.environ["AZURE_OPENAI_API_KEY"],
    api_version=os.environ["AZURE_OPENAI_API_VERSION"]
)

deployment = os.environ["AZURE_OPENAI_DEPLOYMENT"]

response = client.chat.completions.create(
    model=deployment,
    messages=[
        {
            "role": "system",
            "content": (
                "You are a helpful DevOps instructor. "
                "Explain technical concepts simply."
            )
        },
        {
            "role": "user",
            "content": "Explain Kubernetes Services in simple terms."
        }
    ],
    temperature=0.3
)

print(response.choices[0].message.content)
