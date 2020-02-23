resource "aws_security_group" "paxata-server" {

  vpc_id = module.vpc.id

  name = "${var.env-key} paxata-server"

  tags = merge(var.tag-map, map("Name", "${var.env-key} paxata-server","tf-resource", "aws_security_group.paxata-server"))

}

locals {

  public-cidr = var.paxata-office-cidr-map

  instana-ingress-cidr = [ module.instana.instana-repository-cidr-map, module.instana.instana-saas-cidr-map  ]

}


# Allow all VPC traffic in and All Traffic out
module "sg-vpc" {

  source = "../module/security-group-rules"

  sg-id       = aws_security_group.paxata-server.id

  ingress-cidr = [ var.full-subnet-cidr ]

  ingress-rules = [
    {
      action = "allow"
      from-port   = -1
      to-port     = -1
      protocol    = "-1"
      description = "Allow VPC"
    }
  ]

  egress-cidr = ["0.0.0.0/0"]

  egress-rules = [
    {
      action = "allow"
      from-port   = -1
      to-port     = -1
      protocol    = "-1"
      description = "Allow ALL"
    }
  ]
}


# Allow responses / communication with S3
module "sg-aws-s3" {

  source = "../module/security-group-rule-map"

  sg-id       = "${aws_security_group.paxata-server.id}"

  ingress-cidr = ["${ var.s3-cidr-map }"]

  ingress-rules = [
    {
      action = "allow"
      from-port   = "${module.aws.from-port}"
      to-port     = "${module.aws.to-port}"
      protocol    = "tcp"
    }
  ]
}

# Allow HTTP in
module "sg-http" {

  source = "../module/security-group-rule-map"

  sg-id       = "${aws_security_group.paxata-server.id}"

  ingress-cidr = ["${ local.public-cidr }"]

  ingress-rules = [
    {
      action = "allow"
      from-port   = "80"
      to-port     = "80"
      protocol    = "tcp"
    },
    {
      action = "allow"
      from-port   = "443"
      to-port     = "443"
      protocol    = "tcp"
    }
  ]
}

# Allow responses from Instana
module "sg-public-instana" {

  source = "../module/security-group-rule-map"

  sg-id       = "${aws_security_group.paxata-server.id}"

  ingress-cidr = ["${ local.instana-ingress-cidr }"]

  ingress-rules = [
    {
      action = "allow"
      from-port   = "${module.aws.from-port}"
      to-port     = "${module.aws.to-port}"
      protocol    = "tcp"
    }
  ]
}

# Add the WFH ip if it exists
module "sg-wfh" {

  source = "../module/security-group-rule-map"

  create = "${length (var.wfh-ip) > "0"}"

  sg-id       = "${aws_security_group.paxata-server.id}"

  ingress-cidr = "${ local.wfh-map }"

  ingress-rules = [
    {
      action = "allow"
      from-port   = "80"
      to-port     = "80"
      protocol    = "tcp"
    },
    {
      action = "allow"
      from-port   = "443"
      to-port     = "443"
      protocol    = "tcp"
    }
  ]
}
