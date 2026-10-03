variable "ami_id" {
  description = "Insert AMI ID"
  type        = string
}

variable "subnet_id" {
  description = "Insert subnet ID"
  type        = string
}

variable "type" {
  description = "EC2 instance type"
  type        = string
}

variable "key" {
  description = "EC2 key pair name"
  type        = string
}
