
#
# EKS Cluster Resources
#  * EC2 Security Group to allow networking traffic with EKS cluster
# For all regions and environments
# AWS refers this to the "Control Plane Security Group"
resource "aws_security_group" "cluster" {

  name        = "${var.env-key}-cluster"
  description = "Control Plane Security Group"

  vpc_id = local.found-vpc-id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tag-map, map("Name", "${var.env-key}", "tf-resource", "aws_security_group.cluster"))

}
# For all regions and environments
resource "aws_security_group_rule" "cluster-ingress-node-https" {

  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.node.id
  to_port                  = 443
  type                     = "ingress"
}
