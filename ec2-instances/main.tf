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

#
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}


# Resource for the security group
resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  vpc_id = aws_default_vpc.default.id

  # Restrict inbound HTTP access (port 80) to a specific IP address or security group (replace with your desired allowed source)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with specific source
  }

  # ingress rule for SSH access (port 22) with similar restrictions
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with specific source for SSH
  }

  # Egress rule (consider restricting based on your needs)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"] # You might want to restrict outbound traffic based on your application's requirements
  }

  tags = {
    Name = "http_server_sg"
  }
}


# Define the EC2 instance resource
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux_ami.id
  instance_type          = "t2.micro"
  key_name               = "default-key"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  availability_zone      = "us-west-2a"
  subnet_id              = data.aws_subnets.default_subnets.ids[1]

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






