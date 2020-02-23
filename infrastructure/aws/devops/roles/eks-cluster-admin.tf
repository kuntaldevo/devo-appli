

resource "aws_iam_role" "eks-cluster-admin" {

  name = "eks-cluster-admin"

  assume_role_policy = data.aws_iam_policy_document.allow-role-to-be-assumed.json

  description = "Allow a user to talk to existing EKS clusters"

  max_session_duration = "43200"

  tags = var.tag-map

}

resource "aws_iam_role_policy" "eks-cluster-admin" {

  name = "eks-cluster-admin"

  role = aws_iam_role.eks-cluster-admin.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "eks:DescribeCluster"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:eks:*:*:cluster/*"
    },
    {
        "Sid": "VisualEditor1",
        "Effect": "Allow",
        "Action": "eks:ListClusters",
        "Resource": "*"
    }
  ]
}
EOF
}
