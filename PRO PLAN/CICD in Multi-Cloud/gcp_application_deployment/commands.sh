# Create Artifact Registry
gcloud artifacts repositories create demo-repository \
--repository-format=docker \
--location=us-central1


# Run workflow on cloud build
gcloud builds submit \
--config cloudbuild.yaml \
.
