

module "sg-paxata" {

  source = "../module/security-group-rule-map"

  create = "${module.aws.is-not-production}"

  sg-id       = "${aws_security_group.instana-proxy.id}"

  ingress-cidr = "${ var.paxata-office-cidr-map }"

  ingress-rules = [
    {
      action = "allow"
      from-port   = 22
      to-port     = 22
      protocol    = "tcp"
    },
    {
      action = "allow"
      from-port   = 80
      to-port     = 80
      protocol    = "tcp"
    },
    {
      action = "allow"
      from-port   = 443
      to-port     = 443
      protocol    = "tcp"
    }
  ]
}

module "sg-paxata-jumphost" {

  source = "../module/security-group-rule-map"

  sg-id       = "${aws_security_group.instana-proxy.id}"

  ingress-cidr = "${ var.paxata-jumphost-cidr-map }"

  ingress-rules = [
    {
      action = "allow"
      from-port   = 22
      to-port     = 22
      protocol    = "tcp"
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

  security_group_id = "${aws_security_group.instana-proxy.id}"

  description = "WFH"

# Tags N/A
}
