terraform {
  required_version = "= 1.5.7"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = "asia-south1"
}

variable "project_id" {
  type = string
}

variable "bucket_name" {
  type = string
}

resource "google_storage_bucket" "demo_bucket" {
  name                        = var.bucket_name
  location                    = "ASIA-SOUTH1"
  uniform_bucket_level_access = true
}
