
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

# Allow Lambda to write logs to CloudWatch
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Allow Lambda to upload files to S3
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

      Resource = "arn:aws:s3:::jadhav-terraform-12/*"
    }]
  })
}

# Create S3 bucket
resource "aws_s3_bucket" "upload_bucket" {
  bucket = "jadhav-terraform-12"
}

# Create Lambda function
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

resource "aws_s3_object" "zip_upload" {
  bucket = aws_s3_bucket.upload_bucket.id
  key    = "lambda_function.zip"
  source = "${path.module}/lambda_function.zip"
}

