resource "aws_launch_configuration" "antartica_wp_lc" {
  name_prefix          = "antartica_wp_lc_"
  image_id             = "${aws_ami_from_instance.antartica_wp_golden.id}"
  instance_type        = "${var.lc_instance_type}"
  security_groups      = ["${aws_security_group.antartica_private_sg.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.s3_access_profile.id}"
  key_name             = "${aws_key_pair.penguin_auth.id}"
  user_data            = "${file("userdata")}"

  lifecycle {
    # its not going to destroy our outoscaling group before it creates new ones
    # will create new instances before it will destory the current for blue green deployment
    create_before_destroy = true
  }

}
resource "aws_launch_configuration" "north_pole_wp_lc" {
  provider             = aws.central
  name_prefix          = "antartica_wp_lc_"
  image_id             = "${aws_ami_from_instance.north_pole_wp_golden.id}"
  instance_type        = "${var.lc_instance_type}"
  security_groups      = ["${aws_security_group.north_pole_private_sg.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.s3_access_profile.id}"
  key_name             = "${aws_key_pair.penguin_auth.id}"
  user_data            = "${file("userdata")}"

  lifecycle {
    # its not going to destroy our outoscaling group before it creates new ones
    # will create new instances before it will destory the current for blue green deployment
    create_before_destroy = true
  }

}
