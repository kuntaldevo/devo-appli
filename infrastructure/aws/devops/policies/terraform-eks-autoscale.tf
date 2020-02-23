

resource "aws_iam_policy" "terraform-eks-autoscale" {

  name        = "terraform-eks-autoscale"
  path        = "/"
  description = "Allow terraform when creating an EKS cluster to apply the autoscale policies. Only for Groups with 'asg-grp' suffix"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "autoscaling:PutScalingPolicy",
                "autoscaling:DeletePolicy"
            ],
            "Resource": "arn:aws:autoscaling:*:*:autoScalingGroup:*:autoScalingGroupName/*-asg-grp"
        }
    ]
}
EOF
}
