
######## AUTO SCALING GROUP #####
resource "aws_autoscaling_group" "antrartica_asg" {
  name                      = "asg-${aws_launch_configuration.antartica_wp_lc.id}"
  max_size                  = "${var.asg_max}"
  min_size                  = "${var.asg_min}"
  health_check_grace_period = "${var.asg_grace}"
  health_check_type         = "${var.asg_hct}"
  desired_capacity          = "${var.asg_cap}"
  force_delete              = true
  load_balancers            = ["${aws_elb.anatartica_wp_elb.id}"]

  vpc_zone_identifier = ["${aws_subnet.antartica_private1_sunbet.id}, ${aws_subnet.antartica_private2_sunbet.id}"]

  launch_configuration = "${aws_launch_configuration.antartica_wp_lc.name}"
  tag {
    key                 = "Name"
    value               = "wp_asg-instance"
    propagate_at_launch = true # create a tag at lunch
  }

  lifecycle {
    create_before_destroy = true #
  }
}



resource "aws_autoscaling_group" "north_pole_asg" {
  provider                  = aws.central
  name                      = "asg-${aws_launch_configuration.north_pole_wp_lc.id}"
  max_size                  = "${var.asg_max}"
  min_size                  = "${var.asg_min}"
  health_check_grace_period = "${var.asg_grace}"
  health_check_type         = "${var.asg_hct}"
  desired_capacity          = "${var.asg_cap}"
  force_delete              = true
  load_balancers            = ["${aws_elb.north_pole_wp_elb.id}"]

  vpc_zone_identifier = ["${aws_subnet.north_pole_private1_sunbet.id}, ${aws_subnet.north_pole_private1_sunbet.id}"]

  launch_configuration = "${aws_launch_configuration.north_pole_wp_lc.name}"
  tag {
    key                 = "Name"
    value               = "wp_asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}