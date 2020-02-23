

resource "aws_iam_policy" "s3-performance" {

  name        = "s3-performance2"
  path        = "/"
  description = "paxata-performance bucket used for performance testing"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "s3:HeadBucket"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::paxata-performance/*",
                "arn:aws:s3:::paxata-performance"
            ]
        }
    ]
}
EOF
}
