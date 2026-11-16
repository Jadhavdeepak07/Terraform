
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnet_ids
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "rds_secret_arn" {
  value = module.rds.secret_arn
}

output "lambda_name" {
  value = module.lambda.lambda_name
}

output "secrets_manager_endpoint" {
  value = module.vpc_endpoints.secrets_endpoint_id
}
