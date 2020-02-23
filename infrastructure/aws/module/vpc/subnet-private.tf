
resource "aws_subnet" "private" {

  vpc_id = aws_vpc.vpc.id

  cidr_block = var.private-cidr

  availability_zone = var.availability-zone

  tags = merge(var.tag-map, map("Name", "${local.env-key} private","tf-resource", "aws_subnet.private"))

}
