resource "aws_security_group" "paxata" {

  vpc_id = module.vpc.id

  name = "ext-paxata"

  tags = merge(var.tag-map, map("Name", "${var.env-key} paxata whitelist","tf-resource", "aws_security_group.paxata"))

}
