
# -------------------------
# VPC MODULE
# -------------------------

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
}

# -------------------------
# SECURITY GROUP MODULE
# -------------------------

module "security_groups" {
  source = "./modules/security-groups"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

# -------------------------
# RDS MODULE
# -------------------------

module "rds" {
  source = "./modules/rds"

  project_name       = var.project_name
  environment        = var.environment
  db_name            = var.db_name
  db_username        = var.db_username
  db_instance_class  = var.db_instance_class

  subnet_ids         = module.vpc.private_subnet_ids
  rds_security_group = module.security_groups.rds_sg_id
}

# -------------------------
# VPC ENDPOINT MODULE
# -------------------------

module "vpc_endpoints" {
  source = "./modules/vpc-endpoints"

  project_name       = var.project_name
  aws_region         = var.aws_region
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  endpoint_sg_id     = module.security_groups.endpoint_sg_id
}

# -------------------------
# LAMBDA MODULE
# -------------------------

module "lambda" {
  source = "./modules/lambda"

  project_name    = var.project_name
  subnet_ids      = module.vpc.private_subnet_ids
  lambda_sg_id    = module.security_groups.lambda_sg_id
  secret_arn      = module.rds.secret_arn
  db_name         = var.db_name
}

# module "lambda" {
#   source = "./modules/lambda"

#   project_name = var.project_name
#   subnet_ids   = module.vpc.private_subnet_ids
#   lambda_sg_id = module.security_groups.lambda_sg_id
#   secret_arn   = module.rds.secret_arn
#   db_name      = var.db_name

#   depends_on = [
#     module.vpc_endpoints
#   ]
# }