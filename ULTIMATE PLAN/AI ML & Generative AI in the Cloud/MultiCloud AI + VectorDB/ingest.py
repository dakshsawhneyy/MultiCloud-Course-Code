import os
import json
import boto3
import psycopg

from dotenv import load_dotenv
from pgvector.psycopg import register_vector
from pgvector import Vector


# ============================================================
# Configuration
# ============================================================

load_dotenv()

AWS_REGION = os.getenv("AWS_REGION", "us-east-1")

EMBEDDING_MODEL_ID = os.getenv(
    "EMBEDDING_MODEL_ID",
    "amazon.titan-embed-text-v2:0"
)

# PostgreSQL configuration
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

register_vector(conn)


# ============================================================
# Create Embedding
# ============================================================

def create_embedding(text):

    print("Creating embedding...")

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

    embedding = response_body["embedding"]

    return Vector(embedding)


# ============================================================
# Insert Document
# ============================================================

def insert_document(
    title,
    content,
    cloud,
    service,
    document_type
):

    print(f"\nProcessing: {title}")

    # Generate embedding
    embedding = create_embedding(content)

    # Insert into PostgreSQL
    with conn.cursor() as cur:

        cur.execute(
            """
            INSERT INTO documents
            (
                title,
                content,
                cloud,
                service,
                document_type,
                embedding
            )
            VALUES (%s, %s, %s, %s, %s, %s)
            """,
            (
                title,
                content,
                cloud,
                service,
                document_type,
                embedding
            )
        )

    conn.commit()

    print(f"Inserted successfully: {title}")


# ============================================================
# Main
# ============================================================

def main():

    documents = [

        {
            "title": "Amazon EKS",
            "file": "data/aws.txt",
            "cloud": "AWS",
            "service": "EKS",
            "document_type": "cloud"
        },

        {
            "title": "Google GKE",
            "file": "data/gcp.txt",
            "cloud": "GCP",
            "service": "GKE",
            "document_type": "cloud"
        },

        {
            "title": "Kubernetes Deployment",
            "file": "data/kubernetes.txt",
            "cloud": "Kubernetes",
            "service": "Deployment",
            "document_type": "kubernetes"
        }
    ]

    print("=" * 70)
    print("DOCUMENT INGESTION")
    print("AWS Bedrock + PostgreSQL + pgvector")
    print("=" * 70)

    for document in documents:

        print(f"\nReading: {document['file']}")

        with open(
            document["file"],
            "r",
            encoding="utf-8"
        ) as file:

            content = file.read()

        insert_document(
            title=document["title"],
            content=content,
            cloud=document["cloud"],
            service=document["service"],
            document_type=document["document_type"]
        )

    print("\n" + "=" * 70)
    print("ALL DOCUMENTS INGESTED SUCCESSFULLY")
    print("=" * 70)


# ============================================================
# Entry Point
# ============================================================

if __name__ == "__main__":

    try:
        main()

    except Exception as e:

        print("\nERROR:")
        print(e)

    finally:
        conn.close()
