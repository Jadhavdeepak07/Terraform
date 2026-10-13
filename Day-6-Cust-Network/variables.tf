variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}       
variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}
variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  default     = "10.0.2.0/24"
}
variable "availability_zone" {
  description = "Availability zone for the subnets"
  default     = "ap-south-1b"
}   
variable "key_name" {
  description = "Name of the key pair to use for the instance"
  default     = "Laptop"
}
variable "instance_type" {
  description = "Type of the EC2 instance"
  default     = "t2.nano"
}
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-08e3b3155fc937a94"
}
variable "public_ip_cidr" {
  description = "CIDR block for SSH access"
  default     = "10.0.0.0/32"
}
variable "region" {
  description = "AWS region"
  default     = "ap-south-1"
}