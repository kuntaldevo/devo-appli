

locals {
  ingress-join-size = "${length( var.ingress-cidr ) * length( var.ingress-rules )}"

  ingress-cidr-size = length( var.ingress-cidr )
  ingress-rules-size = length( var.ingress-rules )

  ingress-joined-rules-cidrs = data.null_data_source.ingress-join.*.outputs
}


#Perform a cartesian like join of all of the CIDRs to apply to all of the rules
data "null_data_source" "ingress-join" {

  count = "${local.ingress-join-size}"

  inputs = {
    cidr-block = "${ var.ingress-cidr[count.index / local.ingress-cidr-size] }"
    from-port = "${ lookup ( var.ingress-rules[count.index % local.ingress-rules-size],  "from-port" ) }"
    to-port = "${ lookup ( var.ingress-rules[count.index % local.ingress-rules-size],  "to-port" ) }"
    action = "${ lookup ( var.ingress-rules[count.index % local.ingress-rules-size],  "action" ) }"
    protocol = "${ lookup ( var.ingress-rules[count.index % local.ingress-rules-size],  "protocol" ) }"
  }
}


locals {
  egress-join-size = "${length( var.egress-cidr ) * length( var.egress-rules )}"

  egress-cidr-size = "${length( var.egress-cidr )}"
  egress-rules-size = "${length( var.egress-rules )}"

  egress-joined-rules-cidrs = "${data.null_data_source.egress-join.*.outputs}"
}


#Perform a cartesian like join of all of the CIDRs to apply to all of the rules
data "null_data_source" "egress-join" {

  count = "${local.egress-join-size}"

  inputs = {
    action = "${ lookup ( var.egress-rules[count.index % local.egress-rules-size],  "action" ) }"
    cidr-block = "${ var.egress-cidr[count.index / local.egress-cidr-size] }"
    from-port = "${ lookup ( var.egress-rules[count.index % local.egress-rules-size],  "from-port" ) }"
    to-port = "${ lookup ( var.egress-rules[count.index % local.egress-rules-size],  "to-port" ) }"
    protocol = "${ lookup ( var.egress-rules[count.index % local.egress-rules-size],  "protocol" ) }"
  }
}
