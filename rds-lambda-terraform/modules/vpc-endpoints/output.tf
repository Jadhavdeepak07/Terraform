
output "secrets_endpoint_id" {
  value = aws_vpc_endpoint.secrets.id
}

output "logs_endpoint_id" {
  value = aws_vpc_endpoint.logs.id
}
