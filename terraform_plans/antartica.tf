provider "aws" {
  region = "us-east-1"
}
provider "aws" {
  alias  = "central"
  region = "ca-central-1"
}
######################IAM####################
#S3_access

#create a role name s3_access
resource "aws_iam_role" "s3_access_role" {
  name               = "s3_access_role"
  description        = "mission_arctiq: Will allow ec2 to access S3"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "s3_access"
  role = "${aws_iam_role.s3_access_role.name}"
}
#out for testing value
output "aws_iam_instance_profile" {
  value = "${aws_iam_role.s3_access_role.name}"
}
#will create a Role policy name s3_access_policy with the following rule
resource "aws_iam_role_policy" "s3_access_policy" {
  name = "s3_access_policy"
  role = "${aws_iam_role.s3_access_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
######################VPC's####################

# Create a VPC to launch our instances into
resource "aws_vpc" "antartica_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true #A boolean flag to enable/disable DNS support in the VPC. Defaults true.
  enable_dns_hostnames = true #A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false.
  tags = {
    Name = "antartica"
  }

}
resource "aws_vpc" "north_pole_vpc" {
  provider             = aws.central
  cidr_block           = "30.0.0.0/16"
  enable_dns_support   = true #A boolean flag to enable/disable DNS support in the VPC. Defaults true.
  enable_dns_hostnames = true #A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false.
  tags = {
    Name = "north_pole"
  }
}
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
