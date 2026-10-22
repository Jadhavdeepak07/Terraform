
# Variables for Lambda Function and S3 Bucket

variable "jadhavdeep" {
  description = "Name of the Lambda function"
  type        =string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "jadhavdeepak-lambda-s3-upload"
}
