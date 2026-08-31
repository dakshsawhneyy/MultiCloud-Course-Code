terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.project_id
  region = "asia-south1"
}

variable "project_id" {
  type = string
}

variable "bucket_name" {
  type = string
}

resource "google_storage_bucket" "demo_bucket" {
  name     = var.bucket_name
  location = "ASIA-SOUTH1"
  uniform_bucket_level_access = true
}
