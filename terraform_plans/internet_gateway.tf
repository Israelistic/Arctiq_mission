
######################Internet Gateway####################


# Create an internet gateway(ITG) to give our subnet access to the outside world
resource "aws_internet_gateway" "antartica_itg" {
  vpc_id = "${aws_vpc.antartica_vpc.id}" # attached to the VPC
  tags = {
    Name = "ITG_antartica"
  }
}
# Create an internet gateway(ITG) to give our subnet access to the outside world
resource "aws_internet_gateway" "north_pole_itg" {
  provider = aws.central
  vpc_id   = "${aws_vpc.north_pole_vpc.id}" # attached to the VPC
  tags = {
    Name = "ITG_north_pole"
  }
}