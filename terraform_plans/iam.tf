######################IAM####################
#S3_access

#create a role name s3_access
resource "aws_iam_role" "s3_access_role" {
  name               = "s3_access_role"
  description        = "mission_arctiq: Will allow ec2 to access S3"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "s3_access"
  role = "${aws_iam_role.s3_access_role.name}"
}
#out for testing value
output "aws_iam_instance_profile" {
  value = "${aws_iam_role.s3_access_role.name}"
}
#will create a Role policy name s3_access_policy with the following rule
resource "aws_iam_role_policy" "s3_access_policy" {
  name = "s3_access_policy"
  role = "${aws_iam_role.s3_access_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}