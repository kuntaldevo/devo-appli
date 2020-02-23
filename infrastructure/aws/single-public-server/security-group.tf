resource "aws_security_group" "single-server" {

  vpc_id = module.vpc.vpc-id

  tags = merge(var.tag-map, map("Name", "${var.env-key} paxata-server","tf-resource", "aws_security_group.single-server"))

}
