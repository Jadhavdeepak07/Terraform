# creation ec2 instance using open tofu
resource "aws_instance" "my_instance" {
  ami           = "ami-02b2e50944b157a1c"
  instance_type = "t2.micro"
  key_name      = "my-key"
  subnet_id     = "subnet-07a1b04028081083e"

  tags = {
    Name = "Open-Tofu-Instance"
  }
}