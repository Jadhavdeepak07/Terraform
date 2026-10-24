
# 1. Creation of VPC
resource "aws_vpc" "example" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "example-vpc"
  }
}

# 2. Creation of Public/Private Subnet 1
resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "example-subnet-1"
  }
}

# 3. Creation of Subnet 2
resource "aws_subnet" "example2" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "example-subnet-2"
  }
}

# 4. Creation of Security Group
resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Allow MySQL traffic"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-sg"
  }
}

# 5. Creation of RDS Subnet Group
resource "aws_db_subnet_group" "example" {
  name = "example-subnet-group"
  subnet_ids = [
    aws_subnet.example.id,
    aws_subnet.example2.id
  ]

  tags = {
    Name = "example-subnet-group"
  }
}

# 6. Creation of RDS Instance
resource "aws_db_instance" "example" {
  identifier        = "database-1"
  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  db_name           = "database1"
  username          = "admin"
  #   password                = "ChangeMe12345!"
  manage_master_user_password = true
  parameter_group_name        = "default.mysql8.0"
  skip_final_snapshot         = true
  publicly_accessible         = false
  vpc_security_group_ids      = [aws_security_group.example.id]
  db_subnet_group_name        = aws_db_subnet_group.example.name
}
