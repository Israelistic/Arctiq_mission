######################Subnets####################
# I know there must be a way to dry the code.
# Public Subnet
resource "aws_subnet" "antartica_public1_sunbet" {
  vpc_id                  = "${aws_vpc.antartica_vpc.id}"
  cidr_block              = "${var.cidrs_antartica["public1"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "anatrtica_public1"
  }
}
resource "aws_subnet" "antartica_public2_sunbet" {
  vpc_id                  = "${aws_vpc.antartica_vpc.id}"
  cidr_block              = "${var.cidrs_antartica["public2"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  tags = {
    Name = "anatrtica_public2"
  }
}
# Private Subnet
resource "aws_subnet" "antartica_private1_sunbet" {
  vpc_id                  = "${aws_vpc.antartica_vpc.id}"
  cidr_block              = "${var.cidrs_antartica["private1"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "anatrtica_private1"
  }
}
resource "aws_subnet" "antartica_private2_sunbet" {
  vpc_id                  = "${aws_vpc.antartica_vpc.id}"
  cidr_block              = "${var.cidrs_antartica["private2"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  tags = {
    Name = "anatrtica_private2"
  }
}
resource "aws_subnet" "antartica_rds1_sunbet" {
  vpc_id                  = "${aws_vpc.antartica_vpc.id}"
  cidr_block              = "${var.cidrs_antartica["rds1"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "anatrtica_rds1"
  }
}
resource "aws_subnet" "antartica_rds2_sunbet" {
  vpc_id                  = "${aws_vpc.antartica_vpc.id}"
  cidr_block              = "${var.cidrs_antartica["rds2"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  tags = {
    Name = "anatrtica_rds2"
  }
}
resource "aws_subnet" "antartica_rds3_sunbet" {
  vpc_id                  = "${aws_vpc.antartica_vpc.id}"
  cidr_block              = "${var.cidrs_antartica["rds3"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[3]}"
  tags = {
    Name = "anatrtica_rds3"
  }
}

resource "aws_subnet" "north_pole_public1_sunbet" {
  provider                = aws.central
  vpc_id                  = "${aws_vpc.north_pole_vpc.id}"
  cidr_block              = "${var.cidrs_north_pole["public1"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.canada_az[0]}"
  tags = {
    Name = "north_pole_public1"
  }
}
resource "aws_subnet" "north_pole_public2_sunbet" {
  provider                = aws.central
  vpc_id                  = "${aws_vpc.north_pole_vpc.id}"
  cidr_block              = "${var.cidrs_north_pole["public2"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.canada_az[1]}"
  tags = {
    Name = "north_pole_public2"
  }
}
resource "aws_subnet" "north_pole_private1_sunbet" {
  provider                = aws.central
  vpc_id                  = "${aws_vpc.north_pole_vpc.id}"
  cidr_block              = "${var.cidrs_north_pole["private1"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.canada_az[0]}"
  tags = {
    Name = "north_pole_private1"
  }
}
resource "aws_subnet" "north_pole_private2_sunbet" {
  provider                = aws.central
  vpc_id                  = "${aws_vpc.north_pole_vpc.id}"
  cidr_block              = "${var.cidrs_north_pole["private2"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.canada_az[1]}"
  tags = {
    Name = "north_pole_private2"
  }
}
resource "aws_subnet" "north_pole_rds1_sunbet" {
  provider                = aws.central
  vpc_id                  = "${aws_vpc.north_pole_vpc.id}"
  cidr_block              = "${var.cidrs_north_pole["rds1"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.canada_az[0]}"
  tags = {
    Name = "north_pole_rds1"
  }
}
resource "aws_subnet" "north_pole_rds2_sunbet" {
  provider                = aws.central
  vpc_id                  = "${aws_vpc.north_pole_vpc.id}"
  cidr_block              = "${var.cidrs_north_pole["rds2"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.canada_az[1]}"
  tags = {
    Name = "north_pole_rds2"
  }
}
resource "aws_subnet" "north_pole_rds3_sunbet" {
  provider                = aws.central
  vpc_id                  = "${aws_vpc.north_pole_vpc.id}"
  cidr_block              = "${var.cidrs_north_pole["rds3"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.canada_az[1]}"
  tags = {
    Name = "north_pole_rds3"
  }

}
######################Subnets Groups####################
resource "aws_db_subnet_group" "antartica_rds_subnet_grp" {
  name       = "antartica_rds_subnet_grp"
  subnet_ids = ["${aws_subnet.antartica_rds1_sunbet.id}", "${aws_subnet.antartica_rds2_sunbet.id}", "${aws_subnet.antartica_rds3_sunbet.id}"]
  tags = {
    Name = "antartica_rds_sng"
  }
}
resource "aws_db_subnet_group" "north_pole_rds_subnet_grp" {
  provider   = aws.central
  name       = "north_pole_rds_subnet_grp"
  subnet_ids = ["${aws_subnet.north_pole_rds1_sunbet.id}", "${aws_subnet.north_pole_rds2_sunbet.id}", "${aws_subnet.north_pole_rds3_sunbet.id}"]
  tags = {
    Name = "north_pole_rds_sng"
  }
}


######################Subnets Associations####################
# to public rt
resource "aws_route_table_association" "public1_antartica_assoc" {
  subnet_id      = "${aws_subnet.antartica_public1_sunbet.id}"
  route_table_id = "${aws_route_table.antartica_rt.id}"
}
resource "aws_route_table_association" "public2_antartica_assoc" {
  subnet_id      = "${aws_subnet.antartica_public2_sunbet.id}"
  route_table_id = "${aws_route_table.antartica_rt.id}"
}

resource "aws_route_table_association" "public1_north_pole_assoc" {
  provider       = aws.central
  subnet_id      = "${aws_subnet.north_pole_public1_sunbet.id}"
  route_table_id = "${aws_route_table.north_pole_rt.id}"
}
resource "aws_route_table_association" "public2_north_pole_assoc" {
  provider       = aws.central
  subnet_id      = "${aws_subnet.north_pole_public2_sunbet.id}"
  route_table_id = "${aws_route_table.north_pole_rt.id}"
}

# to private rt
resource "aws_route_table_association" "private1_antartica_assoc" {
  subnet_id      = "${aws_subnet.antartica_private1_sunbet.id}"
  route_table_id = "${aws_default_route_table.antartica_private_rt.id}"
}

resource "aws_route_table_association" "private2_antartica_assoc" {
  subnet_id      = "${aws_subnet.antartica_private2_sunbet.id}"
  route_table_id = "${aws_default_route_table.antartica_private_rt.id}"
}
resource "aws_route_table_association" "private1_north_pole_assoc" {
  provider       = aws.central
  subnet_id      = "${aws_subnet.north_pole_private1_sunbet.id}"
  route_table_id = "${aws_default_route_table.north_pole_private_rt.id}"
}
resource "aws_route_table_association" "private2_north_pole_assoc" {
  provider       = aws.central
  subnet_id      = "${aws_subnet.north_pole_private2_sunbet.id}"
  route_table_id = "${aws_default_route_table.north_pole_private_rt.id}"
}