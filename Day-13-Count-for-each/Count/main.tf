
# Variable for instance names
variable "instance_count" {
  type    = list(string)
  default = ["Dev-1", "Test"]
}

# Create EC2 instances
resource "aws_instance" "example" {
  count = length(var.instance_count)

  ami           = "ami-02b2e50944b157a1c"
  instance_type = "t2.micro"
  key_name      = "my-key"
  subnet_id     = "subnet-07a1b04028081083e"

  tags = {
    Name = var.instance_count[count.index]
  }
}
