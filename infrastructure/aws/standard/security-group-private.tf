resource "aws_security_group" "private" {

  vpc_id = module.vpc.id

  name = "${var.env-key} private"

  tags = merge(var.tag-map, map("Name", "${var.env-key} private","tf-resource", "aws_security_group.private"))

}


resource "aws_security_group_rule" "private-inbound" {

  type            = "ingress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks = [ var.full-subnet-cidr ]

  security_group_id = aws_security_group.private.id

  description = "Private inbound all"

# Tags N/A
}

# Allow responses from Instana
module "sg-private-instana" {

  source = "../module/security-group-rule-map"

  sg-id       = aws_security_group.private.id

  ingress-cidr = [ local.instana-ingress-cidr ]

  ingress-rules = [
    {
      action = "allow"
      from-port   = module.aws.from-port
      to-port     = module.aws.to-port
      protocol    = "tcp"
      description = "Instana Responses"
    }
  ]
}


resource "aws_security_group_rule" "private-egress" {

  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = -1
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = aws_security_group.private.id

  description = "Allow ALL outbound"

# Tags N/A
}
