resource "aws_instance" "example" {
  ami           = "ami-088fb12f8e8397f06"
  instance_type = "t2.micro"
  subnet_id     = "subnet-078221674c1f9f44e"

  tags = {
    Name = "Raj"
  }
}
