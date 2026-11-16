# creation of ec2 -instance count and for_each
resource "aws_instance" "example" {
  count         = 3
  ami           = "ami-02b2e50944b157a1c"
  instance_type = "t2.micro"
  key_name      = "my-key"
  subnet_id     = "subnet-07a1b04028081083e"

  tags = {
    Name = "ExampleInstance-${count.index + 1}"
  }
}
