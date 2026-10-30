
resource "aws_instance" "name" {
  ami           = "ami-0c7632fb77f35db43"
  instance_type = "t2.micro"

  subnet_id                   = "subnet-07a1b04028081083e"
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash

    apt update -y
    apt install nginx -y

    systemctl start nginx
    systemctl enable nginx

    echo "<h1>Hello DevOps Project</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "EC2-Server"
  }
}
