
# Multiple inbound rules with different sources

resource "aws_security_group" "sg_multiple_inbound_rules" {
  name        = "multiple-inbound-rules-with-different-source"
  description = "Security group with multiple inbound rules from different sources"
  vpc_id      = "vpc-0c5a181daa9c54ad5"

  # SSH - Port 22
  ingress {
    description = "SSH from private network"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  # HTTP - Port 80
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS - Port 443
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Jenkins - Port 8080
  ingress {
    description = "Jenkins from office network"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["192.168.1.0/24"]
  }

  # MySQL - Port 3306
  ingress {
    description = "MySQL from application network"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-multiple-inbound-rules-with-different-source"
  }
}
