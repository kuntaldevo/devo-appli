

variable "paxata-midwest-cidr" {}
variable "paxata-west-cidr" {}
variable "paxata-jumphost-cidr" { type = list}
variable "wfh-ip" { default = ""}

locals {

  paxata-public-cidr = compact( concat (list (var.paxata-midwest-cidr,var.paxata-west-cidr, var.wfh-ip), var.paxata-jumphost-cidr ) )

}

module "sg-egress-all" {

  source = "../module/security-group-rules"

  sg-id       = aws_security_group.single-server.id

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

  source = "../module/security-group-rules"

  sg-id       = aws_security_group.single-server.id

  ingress-cidr = local.paxata-public-cidr

  ingress-rules = [
    {
      action = "allow"
      from-port   = 22
      to-port     = 22
      protocol    = "tcp"
      description = "Paxata IP"
    }
  ]
}
