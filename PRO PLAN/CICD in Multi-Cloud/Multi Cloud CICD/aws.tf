terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "app" {
  name = var.app_name
}

resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxxxxxxxxxxx"
  instance_type = "t3.micro"
  key_name      = "demo-key-pair"
  tags = {
    Name = "terraform-demo-vm"
  }
}

variable "aws_region" {
  default = "us-east-1"
}

variable "app_name" {
  default = "multi-cloud-app"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}
