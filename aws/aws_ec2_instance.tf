resource "aws_instance" "instance_test" {
    ami           = "ami-08c40ec9ead489470"
    instance_type = "t2.micro"

    network_interface {
      network_interface_id = 
      device_index = 
    }
    tags = {
      "Name" = "Test_ec2"
      "Description" = "i will do it leter"
    }
}
