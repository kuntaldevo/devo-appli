
# At the moment, Terraform is creating some AWS_Instance(s) before all of rules are in place

# This causes Instana Agent to fail during startup.

# To mitigate, I'm going to export the Rule-Id, then add a depends_on to the aws_instance(s)

# Version as of this writing
#Terraform v0.11.3
#+ provider.aws v1.11.0
#+ provider.null v1.0.0
#+ provider.template v1.0.0

output "ingress-nacl-rule-id"
{
  value = "${aws_network_acl_rule.ingress-rules-and-cidr-list.*.id}"
}

output "egress-nacl-rule-id"
{
  value = "${aws_network_acl_rule.egress-rules-and-cidr-list.*.id}"
}
