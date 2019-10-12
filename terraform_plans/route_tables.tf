######################Route Tables####################

#Creat a Route_Table(TR) && Grant the VPC internet access on its antartica route table
resource "aws_route_table" "antartica_rt" {
  vpc_id = "${aws_vpc.antartica_vpc.id}"
  tags = {
    Name = "RT_antartica"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.antartica_itg.id}"
  }
}
#Creat a Route_Table(TR) && Grant the VPC internet access on its north pole route table
resource "aws_route_table" "north_pole_rt" {
  provider = aws.central
  vpc_id   = "${aws_vpc.north_pole_vpc.id}"
  tags = {
    Name = "RT_north_pole"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.north_pole_itg.id}"
  }
}
output "RT_north_pole_id" {
  value = "${aws_route_table.north_pole_rt.id}"
}
#create a default private route table
resource "aws_default_route_table" "antartica_private_rt" {
  default_route_table_id = "${aws_vpc.antartica_vpc.default_route_table_id}"
  tags = {
    Name = "antartica_private_RT"
  }
}


#create a default private route table
resource "aws_default_route_table" "north_pole_private_rt" {
  provider               = aws.central
  default_route_table_id = "${aws_vpc.north_pole_vpc.default_route_table_id}"
  tags = {
    Name = "north_pole_private_RT"
  }
}
