

resource "aws_iam_policy" "elb-describe" {

  name        = "elb-describe"
  path        = "/"
  description = "Allow a user to perform an ELB describe"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "elasticloadbalancing:DescribeLoadBalancers",
            "Resource": "*"
        }
    ]
}
EOF
}
