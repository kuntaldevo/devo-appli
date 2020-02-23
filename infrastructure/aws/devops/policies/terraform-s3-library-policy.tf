

resource "aws_iam_policy" "terraform-s3-library-policy" {

  name        = "terraform-s3-library-policy"
  path        = "/"
  description = "Allow terraform to manage a policy that will allow an EC2 Instance to talk to the Library."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:CreatePolicy",
                "iam:DeletePolicy"
            ],
            "Resource": [
                "arn:aws:iam::*:policy/*library-s3"
            ]
        }
    ]
}
EOF
}
