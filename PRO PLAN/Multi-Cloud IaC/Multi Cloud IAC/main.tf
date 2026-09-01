# GCS Bucket
resource "google_storage_bucket" "demo_bucket" {
  name                        = "student-terraform-gcp-556677"
  location                    = "ASIA-SOUTH1"
  uniform_bucket_level_access = true
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "student-terraform-aws-666666"
} 


# EC2 Instance
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxxxxxxxxxxx"
  instance_type = "t3.micro"

  tags = {
    Name = "terraform-demo-vm"
  }
}


# Compute Engine VM
resource "google_compute_instance" "vm" {
  name         = "terraform-demo-vm"
  machine_type = "e2-micro"
  zone         = "asia-south1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }
}

# =================================================================
# AWS DynamoDB Table
# =================================================================
resource "aws_dynamodb_table" "easy_dynamodb" {
  name         = "easy-terraform-table"
  billing_mode = "PAY_PER_REQUEST" # Serverless/no fixed costs
  hash_key     = "UserId"

  attribute {
    name = "UserId"
    type = "S" # String type
  }
}

# =================================================================
# GCP Firestore / Database Instance
# =================================================================
resource "google_firestore_database" "easy_firestore" {
  name        = "easy-terraform-db"
  location_id = "nam5" # Multi-region US
  type        = "FIRESTORE_NATIVE"
}
