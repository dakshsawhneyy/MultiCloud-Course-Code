resource "google_storage_bucket" "bucket" {
  name     = var.bucket_name
  location = "ASIA-SOUTH1"

  uniform_bucket_level_access = true
}
