terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "student-terraform-demo-UNIQUE-ID"
}

terraform {
  backend "s3" {
    bucket         = "aiops-platform-sf"
    region         = "ap-south-1"
    key            = "aws/terraform.tfstate"
    dynamodb_table = "terraform-lock"
  }
}
