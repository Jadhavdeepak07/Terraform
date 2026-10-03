resource "aws_instance" "name" {
ami= "ami-08e3b3155fc937a94"
subnet_id= "subnet-08b41526dcc329ae2"  
instance_type = "t2.micro"
key_name = "Laptop"
}