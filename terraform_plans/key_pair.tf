resource "aws_key_pair" "penguin_auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.penguin_public_key_path)}"
}

resource "aws_key_pair" "bear_auth" {
  key_name   = "${var.key_name_}"
  public_key = "${file(var.bear_public_key_path)}"
}
