
# VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Custom-VPC"
  }
}

# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.10.16.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet"
  }
}

# Private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = "10.10.17.0/24"

  tags = {
    Name = "Private-Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "Custom-IGW"
  }
}

# Public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

# Public subnet association
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "custom_eip" {
  domain = "vpc"

  tags = {
    Name = "Custom-NAT-EIP"
  }
}

# NAT Gateway in the public subnet
resource "aws_nat_gateway" "custom_nat_gateway" {
  allocation_id = aws_eip.custom_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  depends_on = [aws_internet_gateway.custom_igw]

  tags = {
    Name = "Custom-NAT-Gateway"
  }
}

# Private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.custom_nat_gateway.id
  }

  tags = {
    Name = "Private-Route-Table"
  }
}

# Private subnet association
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}


data "aws_ec2_managed_prefix_list" "ec2_instance_connect" {
  name = "com.amazonaws.ap-south-1.ec2-instance-connect"
}

# Security group for public EC2

resource "aws_security_group" "custom_sg" {
  name        = "Custom-SG"
  description = "Allow SSH from trusted IP and EC2 Instance Connect"
  vpc_id      = aws_vpc.custom_vpc.id

  # SSH from your own public IP
  ingress {
    description = "SSH from trusted IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }
    ingress {
    description = "SSH from trusted IP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  # SSH from EC2 Instance Connect service
  ingress {
    description = "SSH from EC2 Instance Connect"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    prefix_list_ids = [
      data.aws_ec2_managed_prefix_list.ec2_instance_connect.id
    ]
  }

  egress {
    description = "Allow outbound IPv4 traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Custom-SG"
  }
}

# EC2 instance in the public subnet
resource "aws_instance" "custom_instance" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.custom_sg.id]

  tags = {
    Name = "EC2-Public-Instance"
  }
}
