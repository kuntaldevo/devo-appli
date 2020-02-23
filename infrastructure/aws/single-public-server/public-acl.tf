resource "aws_network_acl" "public" {

  vpc_id      = module.vpc.vpc-id
  subnet_ids = [ module.vpc.subnet-id ]

  tags = merge(var.tag-map, map("Name", "public"))
}
