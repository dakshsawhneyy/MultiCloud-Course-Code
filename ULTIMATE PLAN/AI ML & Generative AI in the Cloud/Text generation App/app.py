import boto3

REGION = "us-east-1"

client = boto3.client(
    "bedrock-runtime",
    region_name=REGION
)

MODEL_ID = "amazon.nova-lite-v1:0"

response = client.converse(
    modelId=MODEL_ID,
    system=[
        {
            "text": (
                "You are a senior DevOps engineer. "
                "Explain technical concepts simply "
                "and use practical examples."
            )
        }
    ],
    messages=[
        {
            "role": "user",
            "content": [
                {
                    "text": "Explain Kubernetes in simple terms."
                }
            ]
        }
    ],
    inferenceConfig={
        "maxTokens": 300,
        "temperature": 0.3
    }
)

answer = response["output"]["message"]["content"][0]["text"]

print(answer)
