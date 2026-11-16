
variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "rds_security_group" {
  type = string
}
