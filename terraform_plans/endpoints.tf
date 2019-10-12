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
