# Define required Terraform version and AWS provider configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" # Specify the source of AWS provider
      version = "~> 4.16"       # Specify the version constraint for AWS provider
    }
  }
  required_version = ">= 1.2.0" # Specify the required Terraform version
}

# Configure the AWS provider with the desired region
provider "aws" {
  region = "us-west-2" # Specify the region for the AWS provider
}

# Define an S3 bucket resource
resource "aws_s3_bucket" "my_terraform_s3_bucket" {
  bucket = "my-terraform-bucket-001-20231031120000" # Specify the name for the S3 bucket
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.my_terraform_s3_bucket.id # Reference the ID of the created S3 bucket
  versioning_configuration {
    status = "Enabled" # Enable versioning for the S3 bucket
  }
}

# Define a list of user names
locals {
  user_names = [
    "silver_fox92",
    "luna_starlight",
    "thunder_bolt77",
    "mystic_dreamer",
    "phoenix_rising",
  ]
}

# Create IAM users in AWS for each user name in the list | creating multiple IAM users
resource "aws_iam_user" "my_iam_user" {
  for_each = { for name in local.user_names : name => name } # Specify the user names as keys and values

  name = each.value # Use each user name as the name for the IAM user
}
