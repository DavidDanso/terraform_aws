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

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
