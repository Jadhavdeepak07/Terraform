terraform {
  backend "s3" {
    bucket = "jadhavdeep"
    key = "terrafprm.tfstate"
    dynamodb_table = "deep"
    encrypt = "true"
    use_lockfile = "true"
    region = "ap-south-1"
    
  }
}