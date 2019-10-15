
# Primary Zone
resource "aws_route53_zone" "antartica_primary" {
  name              = "${var.domain_name}.ca"
  delegation_set_id = "${var.delegation_set}"
}

#WWW
resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.antartica_primary.zone_id}"
  name    = "www.${var.domain_name}.ca"
  type    = "A"

  alias { # the alias is point to the load blancer. every time elb changes his ip the alias will help it to follow the address
    name                   = "${aws_elb.anatartica_wp_elb.dns_name}"
    zone_id                = "${aws_elb.anatartica_wp_elb.zone_id}"
    evaluate_target_health = false
  }
}

# Dev
resource "aws_route53_record" "antartica_record_dev" {
  zone_id = "${aws_route53_zone.antartica_primary.zone_id}"
  name    = "dev.${var.domain_name}.ca"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.antartica_penguin_wp_dev.public_ip}"]
}
# Private Zone

resource "aws_route53_zone" "antartica_secondary_record" {
  name = "${var.domain_name}.ca"
  vpc_id = "${aws_vpc.antartica_vpc.id}"
}

#BD
resource "aws_route53_record" "antartica_db_record" {
  zone_id = "${aws_route53_zone.antartica_secondary_record.zone_id}"
  name = "db.${var.domain_name}.ca"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_db_instance.antartica_wp_db.address}"]
}



