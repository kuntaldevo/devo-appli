
resource "aws_network_acl" "proxy" {

  vpc_id = var.vpc-id

  subnet_ids = [ aws_subnet.proxy.id ]

  tags = merge(var.tag-map, map( "tf-resource", "aws_network_acl.proxy"))

}
