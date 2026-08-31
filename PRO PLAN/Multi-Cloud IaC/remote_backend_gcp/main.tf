terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = "YOUR_PROJECT_ID"
  region  = "asia-south1"
}

resource "google_storage_bucket" "demo_bucket" {
  name     = "student-terraform-gcp-UNIQUE-ID"
  location = "ASIA-SOUTH1"
  uniform_bucket_level_access = true
}


# Backend
terraform {
  backend "gcs" {
    bucket = "your-terraform-state-bucket"
    prefix = "terraform/state"
  }
}
