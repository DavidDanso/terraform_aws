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

# Resource for the security group
resource "aws_security_group" "http_server_sg" {
  name        = "http_server_sg"
  vpc_id      = "vpc-0b34c76d8b6819e15"

  # Restrict inbound HTTP access (port 80) to a specific IP address or security group (replace with your desired allowed source)
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]  # Replace with specific source
  }

  # ingress rule for SSH access (port 22) with similar restrictions
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]  # Replace with specific source for SSH
  }

  # Egress rule (consider restricting based on your needs)
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]  # You might want to restrict outbound traffic based on your application's requirements
  }
}