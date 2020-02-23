
locals {

# CIDR that are for Paxata's convenience
paxata-mgt-cidr = [ concat ( var.paxata-office-cidr-map, var.paxata-jumphost-cidr-map ) ]

# The Final CIDR with the customer's as well
proxy-cidr = [ local.paxata-mgt-cidr ]

}


module "proxy-server" {
  source = "../module/proxy-server"

  proxy-server-ami = var.proxy-server-ami
  vpc-id = module.vpc.id
  subnet-cidr = var.devops-subnet-cidr
  aws-key-pair = var.aws-key-pair
  internet-gateway-id = module.vpc.ig-id
  public-domain = var.public-domain
  private-zone-id = aws_route53_zone.private.zone_id
  cidr-blocks = [ local.permitted-cidr ]
  user-data = module.proxy-user-data.user-data


  # Tag Vars
  tag-map = merge(var.tag-map, map("Name", "${var.env-key} proxy-server"))

}

module "proxy-subnet-nacl-vpc" {

  source = "../module/network-acl-rules"

  nacl-id = module.proxy-server.nacl-id

  ingress-cidr = ["0.0.0.0/0"]

  ingress-rules = [
    {
      action = "allow"
      from-port   = -1
      to-port     = -1
      protocol    = "-1"
    }
  ]

  egress-cidr = ["0.0.0.0/0"]

  egress-rules = [
    {
      action = "allow"
      from-port   = -1
      to-port     = -1
      protocol    = "-1"
    }
  ]
}

module "proxy-server-sg" {
  source = "../module/security-group-rule-map"

  sg-id = module.proxy-server.sg-id

  ingress-cidr = local.proxy-cidr

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
    },
    {
      action = "allow"
      from-port   = 4040
      to-port     = 4040
      protocol    = "tcp"
    },
    {
      action = "allow"
      from-port   = 8081
      to-port     = 8081
      protocol    = "tcp"
    },
    {
      action = "allow"
      from-port   = 8090
      to-port     = 8090
      protocol    = "tcp"
    }
  ]

  egress-cidr = ["0.0.0.0/0"]

  egress-rules = [
    {
      action = "allow"
      from-port   = -1
      to-port     = -1
      protocol    = "-1"
    }
  ]
}

module "proxy-server-wfh" {
  source = "../module/security-group-rule-map"

  sg-id = "${module.proxy-server.sg-id}"

  create = "${local.wfh}"

  ingress-cidr = ["${local.wfh-map}"]

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
    },
    {
      action = "allow"
      from-port   = 4040
      to-port     = 4040
      protocol    = "tcp"
    },
    {
      action = "allow"
      from-port   = 8081
      to-port     = 8081
      protocol    = "tcp"
    },
    {
      action = "allow"
      from-port   = 8090
      to-port     = 8090
      protocol    = "tcp"
    }
  ]
}
