resource "aws_security_group" "proxy" {

  vpc_id = var.vpc-id

  tags = merge(var.tag-map, map("tf-resource", "aws_security_group.proxy"))

}
