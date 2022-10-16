#Configured VPC

resource "aws_vpc" "vpc_main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default" 
  tags = {
    "Name" = "vpc_main"
    "Description" = "Main vpc 10.0.0.0/16"
  }
}

#Created gateway for access vpc to internet

resource "aws_internet_gateway" "main_gateway" {
  vpc_id = aws_vpc.vpc_main.id
  tags = {
    "Name" = "main_gateway"
  }
}

#Configured subnet

resource "aws_subnet" "public_subnet_zone_a" {
  vpc_id = aws_vpc.vpc_main.id
  cidr_block = "10.0.30.0/24"
  availability_zone_id = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "pub_sub_zone_a"
  }
}

resource "aws_subnet" "private_subnet_zone_a" {
  vpc_id = aws_vpc.vpc_main.id
  cidr_block = "10.0.35.0/24"
  availability_zone_id = "us-east-1a"
  tags = {
    "Name" = "priv_sub_zone_a"
  }
}

resource "aws_subnet" "public_subnet_zone_b" {
  vpc_id = aws_vpc.vpc_main.id
  cidr_block = "10.0.40.0/24"
  availability_zone_id = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "pub_sub_zone_b"
  }
}


resource "aws_subnet" "private_subnet_zone_b" {
  vpc_id = aws_vpc.vpc_main.id
  cidr_block = "10.0.45.0/24"
  availability_zone_id = "us-east-1b"
  tags = {
    "Name" = "priv_sub_zone_b"
  }
}

#Configure routes

resource "aws_route_table" "route_table_pub" {
  vpc_id = aws_vpc.vpc_main.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.main_gateway.id
    }
  tags = {
    "Name" = "route_table_pub"
    "Description" = "Route tables for public subnet"
  }
}

locals {
  subnet_list_pub = ([ "aws_subnet.public_subnet_zone_a", "aws_subnet.public_subnet_zone_b" ])
#  List of public subnet id
}

resource "aws_route_table_association" "associate_rout_to_subnet" {
  count          = length(local.subnet_list_pub)
  subnet_id      = element(local.subnet_list_pub, count.index)
  route_table_id = aws_route_table.route_table_pub.id
}

locals {
  subnet_list_private = ([ "aws_subnet.private_subnet_zone_a", "aws_subnet.private_subnet_zone_b" ])
#   List of private subnet id
}

resource "aws_nat_gateway" "NAT_priv_subnet" {
  allocation_id = "public"
  count         = length(local.subnet_list_private)
  subnet_id     = element(local.subnet_list_private, count.index)
  tags = {
    "Name" = "NAT_priv_subnet"
    "Description" = "NAT gateway for private subnet"
  }
}
