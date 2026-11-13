
provider "aws" {
  region = "ap-south-1"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# EC2 Security Group
resource "aws_security_group" "sql_runner_sg" {
  name        = "sql-runner-sg"
  description = "Allow SSH access to SQL Runner"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "mysql-rds-sg"
  description = "Allow MySQL only from SQL Runner"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.sql_runner_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 SQL Runner
resource "aws_instance" "sql_runner" {
  ami                         = "ami-088fb12f8e8397f06"
  instance_type               = "t2.micro"
  key_name                    = "OfficePC"
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.sql_runner_sg.id
  ]

  tags = {
    Name = "SQL Runner"
  }
}

# RDS MySQL
resource "aws_db_instance" "mysql_rds" {
  identifier          = "my-mysql-db"
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  username            = "admin"
  password            = var.db_password
  db_name             = "dev"
  allocated_storage   = 20
  publicly_accessible = false
  skip_final_snapshot = true

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]
}

# Remote SQL Execution
resource "null_resource" "remote_sql_exec" {

  depends_on = [
    aws_db_instance.mysql_rds,
    aws_instance.sql_runner
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/Administrator/Downloads/OfficePC.pem")
    host        = aws_instance.sql_runner.public_ip
    timeout     = "5m"
  }

  # Upload SQL file
  provisioner "file" {
    source      = "init.sql"
    destination = "/tmp/init.sql"
  }

  # Execute SQL remotely
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y mariadb105",
      "mysql --version",
      "mysql -h ${aws_db_instance.mysql_rds.address} -u admin -p'${var.db_password}' dev < /tmp/init.sql"
    ]
  }

  # Re-run only when SQL file changes
  triggers = {
    sql_file = filemd5("init.sql")
  }
}
