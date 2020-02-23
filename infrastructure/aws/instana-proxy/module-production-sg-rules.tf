
locals {
  all-public-browsers = [
      {
        cidr = "0.0.0.0/0"
        description = "Customer Browsers"
      } ]
}


module "sg-public-prod" {

  source = "../module/security-group-rule-map"

  create = "${module.aws.is-production}"

  sg-id       = "${aws_security_group.instana-proxy.id}"

  ingress-cidr = "${local.all-public-browsers}"

  ingress-rules = [
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


module "sg-paxata-prod" {

  source = "../module/security-group-rule-map"

  create = "${module.aws.is-production}"

  sg-id       = "${aws_security_group.instana-proxy.id}"

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
