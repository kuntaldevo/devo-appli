#
# EKS Cluster Resources
#  * EKS Cluster
#


#  Had ticket to block public endpoint access for production, but per Scott and network policy we can not create a tunnel from the office to a prod VPC.
#   The network policy is that Paxata tells customers that our office's and employees do not have direct access to production. ( though production direct access via the internet is ok ?)
#   Using IP, whitelists will be sufficient for now.
#locals {
#
## Eventually we will want to block all public access, but for now just block production
#  endpoint-private-access = "${module.aws.is-production}"
#  endpoint-public-access = "${module.aws.is-not-production}"
#
#}


locals {

  create-eks-cluster-role = "${ ( var.provided-eks-cluster-role-arn != "") ? 0 : 1 }"

  generated-eks-cluster-role = "${element(concat(aws_iam_role.cluster.*.arn, list("")), 0)}"

  eks-cluster-role-arn = "${ ( local.create-eks-cluster-role == 0 ) ? var.provided-eks-cluster-role-arn : local.generated-eks-cluster-role }"

}


resource "aws_eks_cluster" "eks" {

  name     = local.cluster-name
  role_arn = local.eks-cluster-role-arn

# Disabled these as they don't seem too useful
# These also create cloudwatch logs which will need to be paired down to a specific size
#  enabled_cluster_log_types = ["api", "audit", "controllerManager", "scheduler"]

  version = "1.14"

  vpc_config {
    security_group_ids = [ aws_security_group.cluster.id ]
    subnet_ids         = data.aws_subnet_ids.all-cluster-subnets.ids
  }

  tags = merge(var.tag-map, map("Name", "${var.env-key}", "tf-resource", "aws_eks_cluster.eks"))

}
