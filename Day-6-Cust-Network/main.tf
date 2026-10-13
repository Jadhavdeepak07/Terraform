# Creation of VPC, Subnet, Internet Gateway, Route Table, and Security Group for a custom network in AWS using Terraform.

# 1. Create VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Custom-VPC"
  }
}

# 2. Create Public Subnet
 resource "aws_subnet" "Public_subnet" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
 
  tags = {
    Name = "Public-Subnet"
  }
}

# 3. Create Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Private-Subnet"
  }
}

# 4. Create Internet Gateway
resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "Custom-IGW"
  }
}

# 5. Create Elastic IP for NAT Gateway
resource "aws_eip" "custom_eip" {
  domain = "vpc"

  tags = {
    Name = "Custom-EIP"
  }
}

# 6. Create NAT Gateway in Public Subnet
resource "aws_nat_gateway" "custom_nat_gateway" {
  allocation_id = aws_eip.custom_eip.id
  subnet_id     = aws_subnet.Public_subnet.id

  depends_on = [aws_internet_gateway.custom_igw]

  tags = {
    Name = "Custom-NAT-Gateway"
  }
}

# 7. Create Public Route Table
resource "aws_route_table" "custom_route_table" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

# 8. Create Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "Private-Route-Table"
  }
}

# 9. Add Default Route Through NAT Gateway
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.custom_nat_gateway.id
}

# 10. Associate Public Route Table
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.Public_subnet.id
  route_table_id = aws_route_table.custom_route_table.id
}

# 11. Associate Private Route Table
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# 12. Create Security Group
resource "aws_security_group" "custom_sg" {
  name        = "custom_sg"
  description = "Allow SSH and outbound traffic"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description = "SSH access - replace with your public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_PUBLIC_IP/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Custom-SG"
  }
}

# 13. Create EC2 Instance in Public Subnet
resource "aws_instance" "custom_instance" {
  ami                         = "ami-08e3b3155fc937a94"
  subnet_id                   = aws_subnet.Public_subnet.id
  instance_type               = "t2.nano"
  key_name                    = "Laptop"
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.custom_sg.id
  ]

  tags = {
    Name = "dev"
  }
}