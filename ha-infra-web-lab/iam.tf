resource "aws_iam_instance_profile" "lab_profile" {
  name = "lab-profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "lab_role"
  path = "/"

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