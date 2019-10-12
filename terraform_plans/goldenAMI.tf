# random ami id

resource "random_id" "golden_ami" {
  byte_length = 3
}

# AMI
resource "aws_ami_from_instance" "antartica_wp_golden" {
  name               = "wp_ami-${random_id.golden_ami.b64}"
  source_instance_id = "${aws_instance.antartica_penguin_wp_dev.id}"

  provisioner "local-exec" {
    command = <<EOT
      cat <<EOF > userdata
      #!/bin/bash
      /usr/bin/aws s3 sync s3://${aws_s3_bucket.antartica_code.bucket} /var/www/html/
      /bin/touch /var/spool/cron/root
      sudo /bin/echo '*/5 * * * * aws s3 sync s3://${aws_s3_bucket.antartica_code.bucket} /var/www/html' >> /var/spool/cron/root
      EOF
      EOT
  }


}
resource "aws_ami_from_instance" "north_pole_wp_golden" {
  provider           = aws.central
  name               = "wp_ami-${random_id.golden_ami.b64}"
  source_instance_id = "${aws_instance.north_pole_bear_wp_dev.id}"

  provisioner "local-exec" {
    command = <<EOT
  cat <<EOF > userdata
  #!/bin/bash
  /usr/bin/aws s3 sync s3://${aws_s3_bucket.north_pole_code.bucket} /var/www/html/
  /bin/touch /var/spool/cron/root
  sudo /bin/echo '*/5 * * * * aws s3 sync s3://${aws_s3_bucket.north_pole_code.bucket} /var/www/html' >> /var/spool/cron/root
  EOF
  EOT
  }


}
