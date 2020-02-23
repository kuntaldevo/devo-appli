#
# Worker Node Security Groups
# EC2 Security Group to allow networking traffic
# For all regions and environments
resource "aws_security_group" "node" {

  name        = "${var.env-key}-node"
  description = "Worker Node Security Group"

  vpc_id = local.found-vpc-id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tag-map, map("Name", "${var.env-key}", "kubernetes.io/cluster/${var.env-key}", "shared", "k8s.io/cluster-autoscaler/${var.env-key}", "owned", "tf-resource", "aws_security_group.node"))
}

# For all regions and environments
resource "aws_security_group_rule" "node-ingress-self" {

  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.node.id
  type                     = "ingress"
}

# For all regions and environments
resource "aws_security_group_rule" "node-ingress-cluster" {

  description              = "Allow worker Kubelets and pods to receive communication from the cluster"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.cluster.id
  type                     = "ingress"
}

# For all regions and environments
resource "aws_security_group_rule" "node-ingress-cluster-443" {

  description              = "Allow worker Kubelets and pods to receive communication from the cluster"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.cluster.id
  type                     = "ingress"
}


#Only add the security group if it's Dev and US-West-2
locals {

  create-ingress-vpn = "${ ( module.aws.is-not-production && ( local.region-id == "us-west-2") ) ? 1 : 0}"

}

# This was initially added to allow TC access.  Personally, not to happy for how wide open it is but what ever
resource "aws_security_group_rule" "node-ingress-vpn" {

  count = local.create-ingress-vpn

  description              = "All Paxata Subnets"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.node.id
  to_port                  = 65535
  type                     = "ingress"
  cidr_blocks = ["10.0.0.0/8"]
}


# Allow SSH in from the office internal or the jump host etc
module "sg-http" {

  source = "../module/security-group-rule-map"

  sg-id = aws_security_group.node.id

  ingress-cidr = var.ssh-ingress-map

  ingress-rules = [
    {
      action = "allow"
      from-port   = "22"
      to-port     = "22"
      protocol    = "tcp"
    }
  ]
}
