

resource "aws_iam_policy" "terraform-create-update" {

  name        = "terraform-create-update2"
  path        = "/"
  description = "Allow user to run a terraform command"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": [
              "autoscaling:DeleteTags",
              "route53:GetChange",
              "ec2:DeleteRoute",
              "route53:GetHostedZone",
              "ec2:DeleteRouteTable",
              "s3:PutObject",
              "s3:GetObject",
              "autoscaling:CreateOrUpdateTags",
              "ec2:DeleteSecurityGroup",
              "route53:ListResourceRecordSets",
              "autoscaling:UpdateAutoScalingGroup",
              "autoscaling:DeleteAutoScalingGroup",
              "ec2:DeleteNetworkAcl",
              "ec2:DeleteNetworkAclEntry"
          ],
          "Resource": [
              "arn:aws:s3:::*/*",
              "arn:aws:autoscaling:*:*:autoScalingGroup:*:autoScalingGroupName/*",
              "arn:aws:ec2:*:*:route-table/*",
              "arn:aws:ec2:*:*:security-group/*",
              "arn:aws:ec2:*:*:network-acl/*",
              "arn:aws:route53:::hostedzone/*",
              "arn:aws:route53:::change/*"
          ]
      },
      {
          "Sid": "VisualEditor1",
          "Effect": "Allow",
          "Action": [
              "autoscaling:DescribeAutoScalingNotificationTypes",
              "ec2:DeleteSubnet",
              "ec2:DescribeInstances",
              "iam:List*",
              "iam:DeleteRolePolicy",
              "iam:CreateRole",
              "autoscaling:DescribeScalingProcessTypes",
              "autoscaling:DescribePolicies",
              "ec2:AttachInternetGateway",
              "ec2:AssociateVpcCidrBlock",
              "ec2:AssociateRouteTable",
              "ec2:DescribeInternetGateways",
              "autoscaling:DescribeAdjustmentTypes",
              "ec2:CreateRoute",
              "ec2:CreateInternetGateway",
              "autoscaling:DescribeAutoScalingGroups",
              "ec2:DescribeAccountAttributes",
              "ec2:DeleteInternetGateway",
              "autoscaling:DescribeNotificationConfigurations",
              "ec2:DescribeKeyPairs",
              "s3:HeadBucket",
              "ec2:DescribeNetworkAcls",
              "ec2:DescribeRouteTables",
              "ec2:DescribeVpcClassicLinkDnsSupport",
              "ec2:CreateTags",
              "ec2:DescribeVpcPeeringConnections",
              "autoscaling:DescribeTags",
              "ec2:CreateRouteTable",
              "ec2:DetachInternetGateway",
              "ec2:DescribeVpcEndpointServiceConfigurations",
              "autoscaling:DescribeMetricCollectionTypes",
              "ec2:DisassociateRouteTable",
              "autoscaling:DescribeLoadBalancers",
              "ec2:DescribeVpcClassicLink",
              "iam:GetInstance*",
              "ec2:DescribeVpcEndpointServicePermissions",
              "ec2:AssociateSubnetCidrBlock",
              "ec2:DescribeVpcEndpoints",
              "ec2:DeleteVpc",
              "eks:ListClusters",
              "ec2:CreateSubnet",
              "ec2:DescribeSubnets",
              "autoscaling:DescribeAutoScalingInstances",
              "ec2:DeleteTags",
              "autoscaling:DescribeTerminationPolicyTypes",
              "autoscaling:DescribeLaunchConfigurations",
              "iam:GetUser*",
              "ec2:CreateVpc",
              "ec2:DescribeVpcEndpointServices",
              "s3:ListBucket",
              "ec2:DescribeVpcAttribute",
              "ec2:DescribeNetworkInterfaces",
              "ec2:DescribeAvailabilityZones",
              "autoscaling:DescribeScalingActivities",
              "ec2:CreateSecurityGroup",
              "autoscaling:DescribeAccountLimits",
              "ec2:CreateNetworkAcl",
              "autoscaling:DescribeScheduledActions",
              "ec2:ModifyVpcAttribute",
              "autoscaling:DescribeLoadBalancerTargetGroups",
              "eks:Describe*",
              "ec2:DescribeVpcEndpointConnections",
              "iam:GetRole*",
              "eks:CreateCluster",
              "autoscaling:DescribeLifecycleHookTypes",
              "ec2:DescribeTags",
              "route53:ListHostedZones",
              "ec2:DescribeVpcEndpointConnectionNotifications",
              "ec2:DescribeSecurityGroups",
              "autoscaling:DescribeLifecycleHooks",
              "ec2:DescribeImages",
              "ec2:CreateLaunchTemplate",
              "iam:CreateServiceLinkedRole",
              "s3:ListAllMyBuckets",
              "ec2:DescribeSecurityGroupReferences",
              "ec2:DescribeVpcs",
              "ec2:CreateNetworkAclEntry",
              "iam:PutRolePolicy"
          ],
          "Resource": "*"
      },
      {
          "Sid": "VisualEditor2",
          "Effect": "Allow",
          "Action": "route53:ChangeResourceRecordSets",
          "Resource": "arn:aws:route53:::hostedzone/*"
      }
  ]
}
EOF
}
