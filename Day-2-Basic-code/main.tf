resource "aws_instance" "name" {
  ami           = var.ami_id
  subnet_id = var.subnet_id
  instance_type = var.type
  key_name      = var.key
}
