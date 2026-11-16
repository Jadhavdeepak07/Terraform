resource "aws_instance" "server" {
  ami           = "ami-02b2e50944b157a1c"
  instance_type = "t2.micro"
  key_name      = "my-key"
  subnet_id     = "subnet-07a1b04028081083e"

  tags = {
    Name = "Devops-Project"
  }
}
resource "aws_s3_bucket" "my_bucket" {
  bucket = "jadhav133333"

  tags = {
    Name        = "jadhav133333"
    Environment = "Dev"
  }
}
# terraform apply -target=aws_s3_bucket.my_bucket