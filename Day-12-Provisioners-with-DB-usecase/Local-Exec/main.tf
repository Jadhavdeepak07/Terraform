
provider "aws" {
  region = "ap-south-1"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MyVPC"
  }
}

# Private Subnet 1
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Private-Subnet-1"
  }
}

# Private Subnet 2
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Private-Subnet-2"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "mysql" {
  name = "mysql-db-subnet-group"

  subnet_ids = [
    aws_subnet.private1.id,
    aws_subnet.private2.id
  ]

  tags = {
    Name = "MySQL-DB-Subnet-Group"
  }
}

# RDS MySQL Instance
resource "aws_db_instance" "mysql_rds" {
  identifier          = "my-mysql-db"
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  username            = "admin"
  password            = "Password123!"
  db_name             = "dev"
  allocated_storage   = 20
  skip_final_snapshot = true

  db_subnet_group_name = aws_db_subnet_group.mysql.name

  publicly_accessible = true
}

# Execute SQL script locally
resource "null_resource" "local_sql_exec" {
  depends_on = [aws_db_instance.mysql_rds]

  provisioner "local-exec" {
    command = "mysql -h ${aws_db_instance.mysql_rds.address} -u admin -pPassword123! dev < test.sql"
  }

  triggers = {
    always_run = timestamp()
  }
}
