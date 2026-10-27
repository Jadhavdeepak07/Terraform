variable "ami_id" {
  type    = string
  default = "ami-088fb12f8e8397f06"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "subnet_id" {
  type    = string
  default = "null"
}

variable "instance_name" {
  type    = string
  default = "Raj"
}
