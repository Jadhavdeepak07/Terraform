module "ec2" {
  source = "../Day-09-modules"

  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  instance_name = var.instance_name
}
