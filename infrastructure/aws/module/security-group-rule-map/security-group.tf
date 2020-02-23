#https://github.com/terraform-aws-modules/terraform-aws-security-group


##########################
# Ingress - Maps of rules
##########################
resource "aws_security_group_rule" "ingress-rules" {

  count = (var.create ? local.ingress-join-size : 0)

  security_group_id = var.sg-id
  type              = "ingress"

  cidr_blocks     = ["${lookup(local.ingress-joined-rules-cidrs[count.index], "cidr-block" ) }"]
  description     = lookup(local.ingress-joined-rules-cidrs[count.index], "description" )

  from_port = lookup(local.ingress-joined-rules-cidrs[count.index], "from-port" )
  to_port   = lookup(local.ingress-joined-rules-cidrs[count.index], "to-port" )
  protocol  = lookup(local.ingress-joined-rules-cidrs[count.index], "protocol" )

}

#########################
# Egress - Maps of rules
#########################

# Security group rules with "cidr_blocks"
resource "aws_security_group_rule" "egress-rules" {

  count = (var.create ? length(var.egress-rules) : 0)

  security_group_id = var.sg-id
  type              = "egress"

  cidr_blocks     = [ var.egress-cidr ]
  description     = lookup(var.egress-rules[count.index], "description", var.egress-description)

  from_port = lookup(var.egress-rules[count.index], "from-port" )
  to_port   = lookup(var.egress-rules[count.index], "to-port" )
  protocol  = lookup(var.egress-rules[count.index], "protocol" )

}
