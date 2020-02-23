
###  Attach Existing Policies that are already in IAM and are listed in `node-policies`
resource "aws_iam_role_policy_attachment" "stage-node-policy" {

  count = length( var.node-policies ) * local.create-instance-profile

  policy_arn = "arn:aws:iam::${local.account-id}:policy/${ element( var.node-policies, count.index) }"

  role       = aws_iam_role.node[0].name
}

resource "aws_iam_role_policy_attachment" "node-policy" {

  count = local.create-instance-profile

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

  role       = aws_iam_role.node[0].name
}

resource "aws_iam_role_policy_attachment" "node-cni-policy" {

  count = local.create-instance-profile

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

  role       = aws_iam_role.node[0].name
}

resource "aws_iam_role_policy_attachment" "node-ec2-registry-readonly" {

  count = local.create-instance-profile

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

  role       = aws_iam_role.node[0].name
}
