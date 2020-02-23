resource "aws_security_group" "vpc" {

  vpc_id = module.vpc.id

  name = "${var.env-key} vpc"

  tags = merge(var.tag-map, map("Name", "${var.env-key} vpc","tf-resource", "aws_security_group.vpc"))

}


locals {

  public-cidr = "${ var.paxata-office-cidr-map }"

}

#Open the following ports. Additional Security is handled by the Network ACL
resource "aws_security_group_rule" "vpc-all-inbound" {
  type            = "ingress"
  from_port       = -1
  to_port         = -1
  protocol        = -1
  cidr_blocks     = ["10.0.0.0/16"]

  security_group_id = aws_security_group.vpc.id

  description = "Allow All VPC"

# Tags N/A
}

#Open the following ports. Additional Security is handled by the Network ACL
resource "aws_security_group_rule" "vpc-all-outbound" {
  type            = "egress"
  from_port       = -1
  to_port         = -1
  protocol        = -1
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = aws_security_group.vpc.id

  description = "Allow All Outbound"

# Tags N/A
}

# Allow official Paxata IPs etc
module "sg-public-paxata" {

  source = "../module/security-group-rule-map"

  sg-id       = aws_security_group.vpc.id

  ingress-cidr = var.paxata-office-cidr-map

  ingress-rules = [
    {
      action = "allow"
      from-port   = -1
      to-port     = -1
      protocol    = "-1"
    }
  ]
}

#Allow WFH to be added if it was provided
resource "aws_security_group_rule" "wfh" {

  count = var.wfh-ip != "" ? 1 : 0

  type            = "ingress"
  from_port       = -1
  to_port         = -1
  protocol        = -1
  cidr_blocks     = ["${var.wfh-ip}/32"]

  security_group_id = aws_security_group.vpc.id

  description = "WFH"

# Tags N/A
}
