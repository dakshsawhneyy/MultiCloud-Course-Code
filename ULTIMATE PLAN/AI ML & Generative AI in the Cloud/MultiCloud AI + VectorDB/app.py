import os
import json
import boto3
import psycopg

from dotenv import load_dotenv
from pgvector.psycopg import register_vector


# ============================================================
# Configuration
# ============================================================

load_dotenv()

AWS_REGION = os.getenv("AWS_REGION", "us-east-1")

# Set this to an embedding model available in your Bedrock region.
EMBEDDING_MODEL_ID = os.getenv(
    "EMBEDDING_MODEL_ID",
    "amazon.titan-embed-text-v2:0"
)

# Set this to a text-generation model available in your region.
GENERATION_MODEL_ID = os.getenv(
    "GENERATION_MODEL_ID",
    "YOUR_GENERATION_MODEL_ID"
)

DB_NAME = os.getenv("POSTGRES_DB", "ragdb")
DB_USER = os.getenv("POSTGRES_USER", "raguser")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD", "ragpassword")
DB_HOST = os.getenv("POSTGRES_HOST", "localhost")
DB_PORT = os.getenv("POSTGRES_PORT", "5432")


# ============================================================
# AWS Bedrock Client
# ============================================================

bedrock = boto3.client(
    "bedrock-runtime",
    region_name=AWS_REGION
)


# ============================================================
# PostgreSQL Connection
# ============================================================

conn = psycopg.connect(
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=DB_PORT
)

# Register pgvector with psycopg
register_vector(conn)


# ============================================================
# Create Embedding
# ============================================================

def create_embedding(text):
    """
    Generate an embedding using AWS Bedrock.
    """

    response = bedrock.invoke_model(
        modelId=EMBEDDING_MODEL_ID,
        body=json.dumps({
            "inputText": text
        }),
        contentType="application/json",
        accept="application/json"
    )

    response_body = json.loads(
        response["body"].read()
    )

    return response_body["embedding"]


# ============================================================
# Search Vector Database
# ============================================================

def search_documents(query, top_k=3):
    """
    Convert the user's query into an embedding and
    retrieve the most similar documents from pgvector.
    """

    query_embedding = create_embedding(query)

    with conn.cursor() as cur:

        cur.execute(
            """
            SELECT
                title,
                content,
                cloud,
                service,
                document_type,
                embedding <=> %s::vector AS distance
            FROM documents
            ORDER BY embedding <=> %s::vector
            LIMIT %s
            """,
            (
                query_embedding,
                query_embedding,
                top_k
            )
        )

        results = cur.fetchall()

    return results


# ============================================================
# Build Context
# ============================================================

def build_context(results):
    """
    Convert retrieved documents into a context string
    that can be passed to the LLM.
    """

    context_parts = []

    for row in results:

        title = row[0]
        content = row[1]
        cloud = row[2]
        service = row[3]
        document_type = row[4]
        distance = row[5]

        context_parts.append(
            f"""
Title: {title}
Cloud: {cloud}
Service: {service}
Document Type: {document_type}
Similarity Distance: {distance}

Content:
{content}
"""
        )

    return "\n\n".join(context_parts)


# ============================================================
# Generate Answer
# ============================================================

def generate_answer(question, context):
    """
    Generate the final answer using Amazon Bedrock
    Converse API.
    """

    system_prompt = """
You are a multi-cloud DevOps assistant.

Answer the user's question using only the
provided context.

Rules:
1. Do not invent information.
2. Prefer information directly supported by the context.
3. If the context does not contain enough information,
   clearly say that the available documents do not
   contain enough information.
4. Give practical and technically accurate answers.
"""

    user_prompt = f"""
Context:

{context}


Question:

{question}
"""

    response = bedrock.converse(
        modelId=GENERATION_MODEL_ID,

        system=[
            {
                "text": system_prompt
            }
        ],

        messages=[
            {
                "role": "user",
                "content": [
                    {
                        "text": user_prompt
                    }
                ]
            }
        ],

        inferenceConfig={
            "maxTokens": 500,
            "temperature": 0.2
        }
    )

    answer = response["output"]["message"]["content"][0]["text"]

    return answer


# ============================================================
# Display Retrieved Documents
# ============================================================

def display_results(results):

    print("\n" + "=" * 70)
    print("RETRIEVED DOCUMENTS")
    print("=" * 70)

    for index, row in enumerate(results, start=1):

        title = row[0]
        cloud = row[2]
        service = row[3]
        distance = row[5]

        print(f"\n[{index}] {title}")
        print(f"    Cloud: {cloud}")
        print(f"    Service: {service}")
        print(f"    Distance: {distance:.4f}")


# ============================================================
# RAG Pipeline
# ============================================================

def rag_pipeline(question):

    print("\nGenerating query embedding...")

    # --------------------------------------------------------
    # 1. Retrieve relevant documents
    # --------------------------------------------------------

    results = search_documents(
        question,
        top_k=3
    )

    if not results:
        print("\nNo documents found.")
        return

    # --------------------------------------------------------
    # 2. Show retrieved documents
    # --------------------------------------------------------

    display_results(results)

    # --------------------------------------------------------
    # 3. Build context
    # --------------------------------------------------------

    context = build_context(results)

    # --------------------------------------------------------
    # 4. Generate answer
    # --------------------------------------------------------

    print("\nGenerating answer using Bedrock...")

    answer = generate_answer(
        question,
        context
    )

    # --------------------------------------------------------
    # 5. Display final response
    # --------------------------------------------------------

    print("\n" + "=" * 70)
    print("ANSWER")
    print("=" * 70)

    print(answer)


# ============================================================
# Main
# ============================================================

def main():

    print("=" * 70)
    print("MULTI-CLOUD RAG - LECTURE 1")
    print("AWS Bedrock + PostgreSQL + pgvector")
    print("=" * 70)

    print(f"\nAWS Region: {AWS_REGION}")
    print(f"Embedding Model: {EMBEDDING_MODEL_ID}")
    print(f"Generation Model: {GENERATION_MODEL_ID}")

    print("\nType 'exit' to quit.")

    while True:

        question = input("\nAsk a question: ").strip()

        if question.lower() == "exit":
            break

        if not question:
            continue

        try:

            rag_pipeline(question)

        except Exception as e:

            print("\nERROR:")
            print(e)

            print(
                "\nCheck your AWS credentials, "
                "Bedrock model access, PostgreSQL connection, "
                "and model IDs."
            )


# ============================================================
# Entry Point
# ============================================================

if __name__ == "__main__":

    try:
        main()

    finally:
        conn.close()
