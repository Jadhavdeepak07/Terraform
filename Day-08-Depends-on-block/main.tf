
# Creation of VPC
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MyFirstVPC"
  }
}

# Creation of subnet
resource "aws_subnet" "mysubnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "MyFirstSubnet"
  }
}

# Creation of security group
resource "aws_security_group" "myec2_sg" {
  name        = "myec2_sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "SSH access"
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
    Name = "MyEC2SecurityGroup"
  }
}

# Creation of EC2 instance
resource "aws_instance" "myec2" {
  ami                    = "ami-088fb12f8e8397f06"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.mysubnet.id
  vpc_security_group_ids = [aws_security_group.myec2_sg.id]

  tags = {
    Name = "MyFirstInstance"
  }
}

# Creation of S3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = "rjhbde"

  tags = {
    Name = "DevTestBucket"
  }
}
