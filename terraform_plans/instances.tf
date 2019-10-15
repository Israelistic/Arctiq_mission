######################Dev Servers####################
# #key pair
# resource "aws_key_pair" "penguin_auth" {
#   key_name   = "${var.key_name}"
#   public_key = "${file(var.penguin_public_key_path)}"
# }

# resource "aws_key_pair" "bear_auth" {
#   key_name   = "${var.key_name_}"
#   public_key = "${file(var.bear_public_key_path)}"
# }


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
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.antartica_penguin_wp_dev.id} --profile haggai && ansible-playbook -i aws_hosts wordpress.yml"
  }
}



resource "aws_instance" "north_pole_bear_wp_dev" {
  provider      = aws.central
  instance_type = "${var.dev_instance_type}"
  ami           = "${var.dev_ami_north_pole}"
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
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.north_pole_bear_wp_dev.id} --profile haggai && ansible-playbook -i aws_hosts wordpress.yml"
  }
}