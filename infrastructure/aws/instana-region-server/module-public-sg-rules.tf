

variable "paxata-office-cidr-map" { type = "list"}
variable "paxata-jumphost-cidr-map" { type = "list"}
variable "ec2-cidr-map" { type = "list"}
variable "wfh-ip" { default = ""}

module "sg-egress-all" {

  source = "../module/security-group-rules"

  sg-id       = "${aws_security_group.paxata.id}"

  egress-rules = [
    {
      action = "allow"
      from-port   = -1
      to-port     = -1
      protocol    = "-1"
      description = "Egress All"
    }
  ]
}

module "sg-paxata" {

  source = "../module/security-group-rule-map"

  sg-id       = "${aws_security_group.paxata.id}"

  ingress-cidr = "${ var.paxata-office-cidr-map }"

  ingress-rules = [
    {
      action = "allow"
      from-port   = 22
      to-port     = 22
      protocol    = "tcp"
    }
  ]
}

module "sg-paxata-jumphost" {

  source = "../module/security-group-rule-map"

  sg-id       = "${aws_security_group.paxata.id}"

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

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["${var.wfh-ip}/32"]

  security_group_id       = "${aws_security_group.paxata.id}"

  description = "WFH"

# Tags N/A
}
