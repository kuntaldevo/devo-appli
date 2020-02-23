
resource "aws_subnet" "public" {

  vpc_id = aws_vpc.vpc.id

  cidr_block = var.public-cidr

  availability_zone = var.availability-zone

  map_public_ip_on_launch = true

  tags = merge(var.tag-map, map("Name", "${local.env-key} public","tf-resource", "aws_subnet.public"))

}
