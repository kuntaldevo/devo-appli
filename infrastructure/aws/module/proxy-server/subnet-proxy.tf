
resource "aws_subnet" "proxy" {

  vpc_id = var.vpc-id

  cidr_block = var.subnet-cidr

  map_public_ip_on_launch = true

  tags = merge(var.tag-map, map( "tf-resource", "aws_subnet.proxy"))

}
