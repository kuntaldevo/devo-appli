#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services

resource "aws_iam_role" "cluster" {

  count = local.create-eks-cluster-role

  name = "${var.env-key}.${local.region-id}.cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster-policy" {

  count = local.create-eks-cluster-role

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  role       = aws_iam_role.cluster[0].name
}

resource "aws_iam_role_policy_attachment" "service-policy" {

  count = local.create-eks-cluster-role

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"

  role       = aws_iam_role.cluster[0].name
}
