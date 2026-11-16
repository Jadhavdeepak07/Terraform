
# Lambda IAM Role

resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "lambda.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

# VPC Network Access Permission

resource "aws_iam_role_policy_attachment" "vpc_access" {
  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Read RDS Secret

resource "aws_iam_role_policy" "secret_access" {
  name = "${var.project_name}-secret-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "secretsmanager:GetSecretValue"
      ]

      Resource = var.secret_arn
    }]
  })
}

# Create Lambda ZIP

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.root}/lambda"
  output_path = "${path.root}/lambda.zip"
}

# Lambda Function

resource "aws_lambda_function" "mysql_lambda" {
  function_name = "${var.project_name}-mysql-lambda"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  role    = aws_iam_role.lambda_role.arn
  handler = "lambda_function.lambda_handler"

  runtime = "python3.12"

  timeout     = 30
  memory_size = 256

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.lambda_sg_id]
  }

  environment {
    variables = {
      SECRET_ARN = var.secret_arn
      DB_NAME    = var.db_name
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.vpc_access,
    aws_iam_role_policy.secret_access
  ]

  tags = {
    Name = "${var.project_name}-lambda"
  }
}


# resource "aws_iam_role_policy_attachment" "basic_logs" {
#   role = aws_iam_role.lambda_role.name

#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }