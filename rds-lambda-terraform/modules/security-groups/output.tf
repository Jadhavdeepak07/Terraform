
output "lambda_sg_id" {
  value = aws_security_group.lambda.id
}

output "rds_sg_id" {
  value = aws_security_group.rds.id
}

output "endpoint_sg_id" {
  value = aws_security_group.endpoint.id
}
