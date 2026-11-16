
resource "aws_vpc_endpoint" "secrets" {
  vpc_id = var.vpc_id

  service_name = "com.amazonaws.${var.aws_region}.secretsmanager"

  vpc_endpoint_type = "Interface"

  subnet_ids         = var.subnet_ids
  security_group_ids = [var.endpoint_sg_id]

  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-secrets-endpoint"
  }
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id = var.vpc_id

  service_name = "com.amazonaws.${var.aws_region}.logs"

  vpc_endpoint_type = "Interface"

  subnet_ids         = var.subnet_ids
  security_group_ids = [var.endpoint_sg_id]

  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-logs-endpoint"
  }
}
