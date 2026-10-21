
# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"

      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach CloudWatch Logs Policy
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create S3 Bucket
resource "aws_s3_bucket" "upload_bucket" {
  bucket = "jadhav-terraform-12"
}

# Allow Lambda to upload objects to S3
resource "aws_iam_role_policy" "lambda_s3_policy" {
  name = "lambda_s3_upload_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "s3:PutObject"
      ]

      Resource = "${aws_s3_bucket.upload_bucket.arn}/*"
    }]
  })
}

# Create Lambda Function
resource "aws_lambda_function" "s3_upload_lambda" {
  function_name = "s3_upload_lambda"

  role    = aws_iam_role.lambda_role.arn
  runtime = "python3.12"
  handler = "lambda_function.lambda_handler"

  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.upload_bucket.bucket
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy,
    aws_iam_role_policy.lambda_s3_policy
  ]
}
