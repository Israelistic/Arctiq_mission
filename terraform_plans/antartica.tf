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
######################Security Groups####################
# Dev Security Group antartica

resource "aws_security_group" "antartica_wp_dev_sg" {
  name        = "wp_dev_sg"
  description = "Used for access to the dev instance"
  vpc_id      = "${aws_vpc.antartica_vpc.id}"
  #SSH access from private ip
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.local_ip}"]
  }
  #HTTP  access from private ip
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.local_ip}"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.local_ip}"]
  }
  egress { # outbound internet access
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
# Dev Security Group north pole

resource "aws_security_group" "north_pole_wp_dev_sg" {
  provider    = aws.central
  name        = "wp_dev_sg"
  description = "Used for access to the dev instance"
  vpc_id      = "${aws_vpc.north_pole_vpc.id}"
  #SSH access from private ip
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.local_ip}"]
  }
  #HTTP  access from private ip
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.local_ip}"]
  }
  #HTTPS access from private ip
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.local_ip}"]
  }
  egress { #outbound internet access
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
#Public Security Group

#Public SG antartica
resource "aws_security_group" "antartica_public_sg" {
  name        = "wp_public_sg"
  description = "Used for the elastic load blancer for public access"
  vpc_id      = "${aws_vpc.antartica_vpc.id}"

  #HTTP  access from private ip
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress { # outbound internet access
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
#Public SG north pole
resource "aws_security_group" "north_pole_public_sg" {
  provider    = aws.central
  name        = "wp_public_sg"
  description = "Used for the elastic load blancer for public access"
  vpc_id      = "${aws_vpc.north_pole_vpc.id}"
  #HTTP  access from private ip
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress { # outbound internet access
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
#Private Security Group

#Private SG antartica
resource "aws_security_group" "antartica_private_sg" {
  name        = "wp_private_sg"
  description = "Used for private instance"
  vpc_id      = "${aws_vpc.antartica_vpc.id}"

  #Access from vpc
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_antartica_cider}"]
  }

  egress { # outbound internet access
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#Private SG north pole
resource "aws_security_group" "north_pole_private_sg" {
  provider    = aws.central
  name        = "wp_private_sg"
  description = "Used for private instance"
  vpc_id      = "${aws_vpc.north_pole_vpc.id}"
  #Access from vpc
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_north_pole_cider}"]
  }

  egress { # outbound internet access
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
#RDS Security Group antartica
resource "aws_security_group" "antartica_RDS_sg" {
  name        = "antartica_wp_rds_sg"
  description = "Used for RDS instances"
  vpc_id      = "${aws_vpc.antartica_vpc.id}"
  #SQL access from public/private security group

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.antartica_wp_dev_sg.id}", "${aws_security_group.antartica_public_sg.id}", "${aws_security_group.antartica_private_sg.id}"]
  }
}
#RDS Security Group north pole
resource "aws_security_group" "north_pole_RDS_sg" {
  provider    = aws.central
  name        = "north_pole_wp_rds_sg"
  description = "Used for RDS instances"
  vpc_id      = "${aws_vpc.north_pole_vpc.id}"
  #SQL access from public/private security group

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.north_pole_wp_dev_sg.id}", "${aws_security_group.north_pole_public_sg.id}", "${aws_security_group.north_pole_private_sg.id}"]
  }
}
# VPC Endpoint for S3
resource "aws_vpc_endpoint" "antartica_wp_private-s3_enpoint" {
  vpc_id       = "${aws_vpc.antartica_vpc.id}"
  service_name = "com.amazonaws.${var.region_antartica}.s3"

  route_table_ids = ["${aws_default_route_table.antartica_private_rt.id}", "${aws_route_table.antartica_rt.id}"]
  policy          = <<POLICY
{
    "Statement": [
      {
        "Action": "*",
        "Effect": "Allow",
        "Resource": "*",
        "Principal": "*"
      }
    ]
}
POLICY
}

# VPC Endpoint for S3
resource "aws_vpc_endpoint" "north_pole_wp_private-s3_enpoint" {
  provider        = aws.central
  vpc_id          = "${aws_vpc.north_pole_vpc.id}"
  service_name    = "com.amazonaws.${var.region_north_pole}.s3"
  route_table_ids = ["${aws_default_route_table.north_pole_private_rt.id}", "${aws_route_table.north_pole_rt.id}"]
  policy          = <<POLICY
{
    "Statement": [
      {
        "Action": "*",
        "Effect": "Allow",
        "Resource": "*",
        "Principal": "*"
      }
    ]
}
POLICY
}

# -----S# code bucket ---------
resource "random_id" "antartica_wp_code_bucket" {
  byte_length = 2
}

resource "random_id" "north_pole_wp_code_bucket" {
  byte_length = 2
}

resource "aws_s3_bucket" "antartica_code" {
  bucket        = "${var.domain_name}-${random_id.antartica_wp_code_bucket.dec}"
  acl           = "private"
  force_destroy = true
  tags = {
    Name = "antartica_code_bucket"
  }
}
resource "aws_s3_bucket" "north_pole_code" {
  provider      = aws.central
  bucket        = "${var.domain_name}-${random_id.north_pole_wp_code_bucket.dec}"
  acl           = "private"
  force_destroy = true
  tags = {
    Name = "north_pole_code_bucket"
  }
}
######################RDS Instances####################
resource "aws_db_instance" "antartica_wp_db" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.6.34"
  instance_class         = "${var.db_instance_class}"
  name                   = "${var.dbname1}"
  username               = "${var.dbuser}"
  password               = "${var.dbpassword}"
  db_subnet_group_name   = "${aws_db_subnet_group.antartica_rds_subnet_grp.name}"
  vpc_security_group_ids = ["${aws_security_group.antartica_RDS_sg.id}"]
  skip_final_snapshot    = true
}
resource "aws_db_instance" "north_pole_wp_db" {
  provider               = aws.central
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.6.34"
  instance_class         = "${var.db_instance_class}"
  name                   = "${var.dbname2}"
  username               = "${var.dbuser}"
  password               = "${var.dbpassword}"
  db_subnet_group_name   = "${aws_db_subnet_group.north_pole_rds_subnet_grp.name}"
  vpc_security_group_ids = ["${aws_security_group.north_pole_RDS_sg.id}"]
  skip_final_snapshot    = true
}
######################Dev Servers####################
#key pair
resource "aws_key_pair" "penguin_auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.penguin_public_key_path)}"
}




#antartiaca_dev server

resource "aws_instance" "antartica_penguin_wp_dev" {
  instance_type = "${var.dev_instance_type}"
  ami           = "${var.dev_ami_antartica}"
  tags = {
    Name = "penguin_wp_dev"
  }
  key_name               = "${aws_key_pair.penguin_auth.id}"
  vpc_security_group_ids = ["${aws_security_group.antartica_wp_dev_sg.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.s3_access_profile.id}"
  subnet_id              = "${aws_subnet.antartica_public1_sunbet.id}"
  provisioner "local-exec" {
    command = <<EOD
cat <<EOF > aws_hosts
[dev]
${aws_instance.antartica_penguin_wp_dev.public_ip}
[dev:vars]
s3code=${aws_s3_bucket.antartica_code.bucket}
domain=${var.domain_name}
EOF
EOD
  }
  provisioner "local-exec" {
    command = "aws ec2 wait in instance-status-ok --instance-ids ${aws_instance.antartica_penguin_wp_dev.id}  --profile haggai && ansible-playbook -i aws_hosts wordpress.yml"
  }
}

resource "aws_key_pair" "bear_auth" {
  key_name   = "${var.key_name_}"
  public_key = "${file(var.bear_public_key_path)}"
}

resource "aws_instance" "north_pole_bear_wp_dev" {
  provider     = aws.central
  instance_type = "${var.dev_instance_type}"
  ami          = "${var.dev_ami_north_pole}"
  tags = {
    Name = "penguin_wp_dev"
  }
  key_name               = "${aws_key_pair.bear_auth.id}"
  vpc_security_group_ids = ["${aws_security_group.north_pole_wp_dev_sg.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.s3_access_profile.id}"
  subnet_id              = "${aws_subnet.north_pole_public1_sunbet.id}"
  provisioner "local-exec" {
    command = <<EOD
cat <<EOF > aws_hosts
[dev]
${aws_instance.north_pole_bear_wp_dev.public_ip}
[dev:vars]
s3code=${aws_s3_bucket.north_pole_code.bucket}
domain=${var.domain_name}
EOF
EOD
  }
  provisioner "local-exec" {
    command = "aws ec2 wait in instance-status-ok --instance-ids ${aws_instance.north_pole_bear_wp_dev.id}  --profile haggai && ansible-playbook -i aws_hosts wordpress.yml"
  }
}

