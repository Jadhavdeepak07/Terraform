
variable "project_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "lambda_sg_id" {
  type = string
}

variable "secret_arn" {
  type = string
}

variable "db_name" {
  type = string
}
