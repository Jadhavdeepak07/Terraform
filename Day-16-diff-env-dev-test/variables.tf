provider "aws" {
    profile = "dev"
    alias   = "dev_nit"
  region = "ap-south-1"
}
provider "aws" {
    profile = "test"
    alias   = "test_nit"
  region = "ap-south-1" 
}