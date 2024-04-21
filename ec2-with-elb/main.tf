terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Resource for the default VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Resource for the security group
resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "http_server_sg"
  }
}

# Define the EC2 instance resource
locals {
  subnet_ids = toset(data.aws_subnets.default_subnets.ids)
}

resource "aws_instance" "web_server" {
  for_each = { for idx, subnet_id in local.subnet_ids : idx => subnet_id }

  ami                    = data.aws_ami.amazon_linux_ami.id
  instance_type          = "t2.micro"
  key_name               = "default-key"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  subnet_id              = each.value

  tags = {
    Name = "http_servers_${each.value}"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file(var.aws_key_pair)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "echo '<h1>Hello, World! Terraform Configuration! - Virtual Server is at ${self.private_dns}</h1>' | sudo tee /var/www/html/index.html",
    ]
  }
}