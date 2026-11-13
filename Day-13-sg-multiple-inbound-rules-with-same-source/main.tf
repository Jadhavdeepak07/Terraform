
# Security Group

resource "aws_security_group" "sg_multiple_inbound_rules" {
  name        = "multiple-inbound-rules"
  description = "Security group with multiple inbound rules from same source"
  vpc_id      = "vpc-0c5a181daa9c54ad5"

  dynamic "ingress" {
    for_each = [22, 80, 443]

    content {
      description = "Allow traffic from same source"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-multiple-inbound-rules"
  }
}

# EC2 Instance

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-key"
  subnet_id     = "subnet-07a1b04028081083e"

  vpc_security_group_ids = [
    aws_security_group.sg_multiple_inbound_rules.id
  ]

  tags = {
    Name = "ExampleInstance"
  }
}
