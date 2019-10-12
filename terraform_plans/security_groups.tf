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