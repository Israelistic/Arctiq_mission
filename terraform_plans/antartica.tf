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
  enable_dns_support  = true #A boolean flag to enable/disable DNS support in the VPC. Defaults true.
  enable_dns_hostnames  = true #A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false.
  tags = {
    Name = "antartica"
  }

}
resource "aws_vpc" "north_pole" {
  provider = aws.central
  cidr_block = "30.0.0.0/16"
  enable_dns_support  = true #A boolean flag to enable/disable DNS support in the VPC. Defaults true.
  enable_dns_hostnames  = true #A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false.
  tags = {
    Name = "north_pole"
  }
}
# Create an internet gateway(ITG) to give our subnet access to the outside world
resource "aws_internet_gateway" "antartica" {
  vpc_id = "${aws_vpc.antartica.id}"   # attached to the VPC
  tags = {
    Name = "ITG_antartica"
  }
}
# Create an internet gateway(ITG) to give our subnet access to the outside world
resource "aws_internet_gateway" "north_pole" {
  provider = aws.central
  vpc_id = "${aws_vpc.north_pole.id}"  # attached to the VPC
  tags = {
    Name = "ITG_north_pole"
  }
}
#Creat a Route_Table(TR) && Grant the VPC internet access on its antartica route table
resource "aws_route_table" "antartica" {
  vpc_id = "${aws_vpc.antartica.id}"
  tags = {
    Name = "RT_antartica"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.antartica.id}"
  }
}
#Creat a Route_Table(TR) && Grant the VPC internet access on its north pole route table
resource "aws_route_table" "north_pole" {
  provider = aws.central
  vpc_id = "${aws_vpc.north_pole.id}"
  tags = {
    Name = "RT_north_pole"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.north_pole.id}"
  }
}
output "RT_north_pole_id" {
    value = "${aws_route_table.north_pole.id}"
  }


# Create a Public  && Private subnet for antartica
resource "aws_subnet" "antartica_subnet1" {
  vpc_id                  = "${aws_vpc.antartica.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true #Auto-assign public IPv4 address
  tags = {
    Name = "_public_antartica"
  }
}
resource "aws_route_table_association" "antartica" {
	subnet_id = "${aws_subnet.antartica_subnet1.id}"
	route_table_id = "${aws_route_table.antartica.id}"
}

resource "aws_subnet" "antartica_subnet2" {
  vpc_id                  = "${aws_vpc.antartica.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true #Auto-assign public IPv4 address
  tags = {
    Name = "_private_antartica"
  }
}
# Create a Public  && Private subnet for north_pole
resource "aws_subnet" "north_pole1" {
  provider = aws.central
  vpc_id                  = "${aws_vpc.north_pole.id}"
  cidr_block              = "30.0.1.0/24"
  map_public_ip_on_launch = true #Auto-assign public IPv4 address
  tags = {
    Name = "_public_north_pole"
  }
}
# output subnet id for testing purposes
output "north_pole1_id" {
	value = "${aws_subnet.north_pole1.id}"
}
resource "aws_route_table_association" "north_pole" {
  provider = aws.central
	subnet_id = "${aws_subnet.north_pole1.id}"
	route_table_id = "${aws_route_table.north_pole.id}"
}
resource "aws_subnet" "north_pole2" {
  provider = aws.central
  vpc_id                  = "${aws_vpc.north_pole.id}"
  cidr_block              = "30.0.2.0/24"
  map_public_ip_on_launch = true #Auto-assign public IPv4 address
  tags = {
    Name = "_private_north_pole"
  }
}
# # Grant the VPC internet access on its antartica route table
# resource "aws_route" "internet_access" {
#   route_table_id         = "${aws_vpc.antartica.main_route_table_id}"
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = "${aws_internet_gateway.antartica.id}"

# }