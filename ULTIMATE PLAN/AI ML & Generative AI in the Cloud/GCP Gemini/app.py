from google import genai
from google.genai.types import HttpOptions
import os

client = genai.Client(
    vertexai=True,
    project=os.environ["GOOGLE_CLOUD_PROJECT"],
    location=os.environ["GOOGLE_CLOUD_LOCATION"],
    http_options=HttpOptions(api_version="v1")
)

response = client.models.generate_content(
    model="gemini-2.5-flash",
    contents="Explain Kubernetes Services in simple terms."
)

print(response.text)
