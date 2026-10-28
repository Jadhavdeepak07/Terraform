
module "s3_bucket" {
  source = "git::https://github.com/Jadhavdeepak07/terraform-aws-s3-bucket.git"


  bucket = "my-s3-terraform513"

  versioning = {
    enabled = true
  }

  tags = {
    Name        = "my-s3-terraform513"
    Environment = "Dev"
  }
}
