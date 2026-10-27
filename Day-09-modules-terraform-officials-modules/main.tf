module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = "my-s3-bucket555"

  versioning = {
    enabled = true
  }

  tags = {
    Name        = "My-S3-Bucket58611"
    Environment = "Dev"
  }
}
