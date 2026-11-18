# diff env dev test     
resource "aws_s3_bucket" "dev_test_bucket" {
  bucket = "dev-test-bucket"
  provider = aws.dev_nit
  }

resource "aws_s3_bucket" "test_bucket" {
  bucket = "test-bucket"
  provider = aws.test_nit
  }
 
