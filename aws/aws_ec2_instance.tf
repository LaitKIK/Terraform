resource "aws_instance" "instance_test" {
    ami =  "ami-08c40ec9ead489470"
    instance_type = "t2.micro"
}
