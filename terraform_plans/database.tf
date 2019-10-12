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