

resource "aws_iam_policy" "eks-dev" {

  name        = "eks-dev"
  path        = "/"
  description = "Alowed EKS access for Development team"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:CreateInstanceProfile",
                "ec2:AuthorizeSecurityGroupIngress",
                "cloudformation:ListStackInstances",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:CreateRole",
                "iam:AttachRolePolicy",
                "iam:AddRoleToInstanceProfile",
                "iam:PassRole",
                "iam:DetachRolePolicy",
                "ec2:RevokeSecurityGroupEgress",
                "cloudformation:CreateStackSet",
                "iam:DeleteInstanceProfile",
                "ec2:AuthorizeSecurityGroupEgress",
                "cloudformation:DescribeStackInstance",
                "iam:DeleteRole",
                "cloudformation:DeleteStackSet",
                "cloudformation:DescribeStacks",
                "ec2:RevokeSecurityGroupIngress",
                "autoscaling:CreateLaunchConfiguration",
                "cloudformation:DescribeStackSet",
                "cloudformation:ListStackSets",
                "autoscaling:DeleteLaunchConfiguration",
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "autoscaling:DeleteAutoScalingGroup",
                "autoscaling:CreateAutoScalingGroup"
            ],
            "Resource": [
                "arn:aws:ec2:*:${var.account-id}:security-group/*",
                "arn:aws:autoscaling:*:${var.account-id}:autoScalingGroup:*:autoScalingGroupName/*",
                "arn:aws:autoscaling:*:${var.account-id}:launchConfiguration:*:launchConfigurationName/*",
                "arn:aws:cloudformation:*:${var.account-id}:stack/*/*",
                "arn:aws:cloudformation:*:${var.account-id}:stackset/*:*",
                "arn:aws:iam::${var.account-id}:role/*",
                "arn:aws:iam::${var.account-id}:instance-profile/*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "cloudformation:ListStacks",
                "eks:*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Deny",
            "Action": [
                "eks:DeleteCluster",
                "eks:UpdateClusterVersion"
            ],
            "Resource": "arn:aws:eks:*:*:cluster/paxata-test-eks"
        }
    ]
}
EOF
}
