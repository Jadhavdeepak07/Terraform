
# Variable for instance names
variable "instance" {
  type    = list(string)
  default = ["Dev-1", "Test"]
}

# Create EC2 instances
resource "aws_instance" "example" {

  ami           = "ami-02b2e50944b157a1c"
  instance_type = "t2.micro"

  for_each = toset(var.instance)

  key_name  = "my-key"
  subnet_id = "subnet-07a1b04028081083e"

  tags = {
    Name = each.key
  }
}
