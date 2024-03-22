# Define required Terraform version and AWS provider configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"   # Specify the source of AWS provider
      version = "~> 4.16"          # Specify the version constraint for AWS provider
    }
  }
  required_version = ">= 1.2.0"    # Specify the required Terraform version
}

# Configure the AWS provider with the desired region
provider "aws" {
  region  = "us-west-2"          # Specify the region for the AWS provider
}

# Define an S3 bucket resource
resource "aws_s3_bucket" "my_terraform_s3_bucket" {
    bucket = "my-terraform-bucket-001-20231031120000"  # Specify the name for the S3 bucket
}


