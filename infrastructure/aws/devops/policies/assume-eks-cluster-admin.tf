

resource "aws_iam_policy" "assume-eks-cluster-admin" {

  name        = "assume-eks-cluster-admin"
  path        = "/"
  description = "Allow a Role to Assume the All EKS access role "

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::${var.account-id}:role/eks-cluster-admin"
        }
    ]
}
EOF
}
