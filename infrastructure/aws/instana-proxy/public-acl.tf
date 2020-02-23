resource "aws_network_acl" "public" {

  vpc_id      = module.vpc.id
  subnet_ids = [module.vpc.public-subnet-id]

  tags = merge(var.tag-map, map("Name", "public"))
}
