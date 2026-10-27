
# Create EC2 using existing Subnet and Security Group
resource "aws_instance" "example" {
  ami           = "ami-088fb12f8e8397f06"
  instance_type = "t2.micro"

  # Existing Subnet ID
  subnet_id = "subnet-08b41526dcc329ae2"

  # Existing Security Group ID
  vpc_security_group_ids = [
    "sg-021228eba75101325"
  ]

  # Existing Key Pair
  key_name = "Laptop"

  tags = {
    Name = "Terraform-EC2"
  }
}
