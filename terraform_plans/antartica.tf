provider "aws" {
  region = "us-east-1"
}
provider "aws" {
  alias  = "central"
  region = "ca-central-1"
}
# Create a VPC to launch our instances into
resource "aws_vpc" "antartica" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames  = true #A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false.
  tags = {
    Name = "antartica"
  }

}
resource "aws_vpc" "north_pole" {
  provider = aws.central
  cidr_block = "30.0.0.0/16"
  enable_dns_hostnames  = true #A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false.

    tags = {
    Name = "north_pole"
  }
}
# Create an internet gateway(ITG) to give our subnet access to the outside world
resource "aws_internet_gateway" "antartica" {
  vpc_id = "${aws_vpc.antartica.id}"
  tags = {
    Name = "ITG_antartica"
  }
}
#Creat a Route_Table(TR) && Grant the VPC internet access on its antartica route table
resource "aws_route_table" "antartica" {
  vpc_id = "${aws_vpc.antartica.id}"
tags = {
    Name = "antartica"
  }
   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.antartica.id}"
  }
}
resource "aws_subnet" "antartica" {
  vpc_id                  = "${aws_vpc.antartica.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true #Auto-assign public IPv4 address
tags = {
    Name = "_public_antartica"
  }
}
resource "aws_subnet" "antartica1" {
  vpc_id                  = "${aws_vpc.antartica.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true #Auto-assign public IPv4 address
tags = {
    Name = "_private_antartica"
  }
}
# # Grant the VPC internet access on its antartica route table
# resource "aws_route" "internet_access" {
#   route_table_id         = "${aws_vpc.antartica.main_route_table_id}"
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = "${aws_internet_gateway.antartica.id}"

# }