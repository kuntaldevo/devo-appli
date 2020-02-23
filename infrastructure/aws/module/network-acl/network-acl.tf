#################
# Network ACL
#################
resource "aws_network_acl" "this" {
  count = "${var.create}"

  vpc_id      = var.vpc-id
  subnet_ids = [var.subnet-id]

  tags = merge(var.tag-map, map("Name", format("%s", var.name)))
}



##########################
# Ingress - Maps of rules
##########################
# Takes a list of 'ingress-rules' where each list item is a Map with the following keys
#  action: ether "allow" or "deny"
#  from-port: a port number
#  to_port:   a port number
#  protocol: A string like "tpc" or "-1"
# Additionally uses the 'ingress-cidrs'
resource "aws_network_acl_rule" "ingress-rules-and-cidr-list" {

  count = var.create ? length(local.ingress-join-size) : 0

  network_acl_id = aws_network_acl.this.id
  egress              = false

  rule_number     = "${count.index + 1}"
  rule_action     = lookup( local.ingress-joined-rules-cidrs[count.index], "action", "")

  cidr_block     = lookup(local.ingress-joined-rules-cidrs[count.index], "cidr-block", "")

  from_port    = lookup(local.ingress-joined-rules-cidrs[count.index], "from-port", "")
  to_port     = lookup(local.ingress-joined-rules-cidrs[count.index], "to-port", "")
  protocol    = lookup(local.ingress-joined-rules-cidrs[count.index], "protocol", "")

}


#################
# End of ingress
#################

##################################
# Egress - List of rules (simple)
##################################
resource "aws_network_acl_rule" "egress-rules-and-cidr-list" {

  count = var.create ? length(local.egress-join-size) : 0

  network_acl_id = aws_network_acl.this.id
  egress              = true

  rule_number     = count.index + 1
  rule_action     = lookup( local.egress-joined-rules-cidrs[count.index], "action", "")

  cidr_block     = lookup(local.egress-joined-rules-cidrs[count.index], "cidr-block", "")

  from_port    = lookup(local.egress-joined-rules-cidrs[count.index], "from-port", "")
  to_port     = lookup(local.egress-joined-rules-cidrs[count.index], "to-port", "")
  protocol    = lookup(local.egress-joined-rules-cidrs[count.index], "protocol", "")

}

################
# End of egress
################
