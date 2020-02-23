

resource "aws_iam_policy" "terraform-eks-cloudwatch" {

  name        = "terraform-eks-cloudwatch"
  path        = "/"
  description = "Allow terraform when creating an EKS cluster to apply the cloudwatch alarms for autoscaling."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricAlarm",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:DeleteAlarms"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
