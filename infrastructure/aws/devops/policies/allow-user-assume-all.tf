
resource "aws_iam_policy" "allow-user-all-assume" {

  name        = "allow-user-all-assume"
  path        = "/"
  description = "Allow a User to Assume any and all role "

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "*"
        }
    ]
}
EOF
}
