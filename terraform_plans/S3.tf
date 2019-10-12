# -----S3 code bucket ---------
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