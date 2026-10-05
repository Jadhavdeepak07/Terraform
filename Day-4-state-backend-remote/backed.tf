terraform {
  backend "s3" {
    bucket = "jadhavdeep"
    key = "terraform.tfstate"
    region = "ap-south-1"
    
  }
}