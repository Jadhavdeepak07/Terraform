
variable "db_password" {
  description = "RDS MySQL password"
  type        = string
  sensitive   = true
}

variable "ssh_cidr" {
  description = "Public IP for SSH access"
  type        = string
}
