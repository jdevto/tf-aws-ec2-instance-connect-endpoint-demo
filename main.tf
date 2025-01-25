# Generate a random suffix for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  name = "ec2-instance-connect-endpoint-demo-${random_string.suffix.result}"
}

# Create VPC
resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = local.name
  }
}

# Create Private Subnet (for EC2 Instance Connect Endpoint)
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "${local.name}-private"
  }
}

# Retrieve your public ip
data "http" "my_public_ip" {
  url = "http://ifconfig.me/ip"
}

# Create Security Group for EC2 Instances
resource "aws_security_group" "ec2_connect" {
  name        = "${local.name}-sg"
  description = "Allow SSH traffic from EC2 Instance Connect Endpoint"
  vpc_id      = aws_vpc.example.id

  # Allow SSH only from EC2 Instance Connect Endpoint
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.http.my_public_ip.response_body}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name}-sg"
  }
}

# Create EC2 Instance Connect Endpoint
resource "aws_ec2_instance_connect_endpoint" "example" {
  subnet_id          = aws_subnet.private.id
  security_group_ids = [aws_security_group.ec2_connect.id]

  tags = {
    Name = local.name
  }
}

# Fetch Latest Amazon Linux 2 AMI
data "aws_ami" "amzn2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# Fetch Latest Amazon Linux 2023 AMI
data "aws_ami" "amzn2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

# Create EC2 Instances in Private Subnet using EC2 Instance Connect Endpoint
resource "aws_instance" "jumphost1" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private.id

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname jumphost1
  EOF

  vpc_security_group_ids = [
    aws_security_group.ec2_connect.id
  ]

  tags = {
    Name = "${local.name}-jumphost1"
  }
}

resource "aws_instance" "jumphost2" {
  ami           = data.aws_ami.amzn2023.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private.id

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname jumphost2
  EOF

  vpc_security_group_ids = [
    aws_security_group.ec2_connect.id
  ]

  tags = {
    Name = "${local.name}-jumphost2"
  }
}
