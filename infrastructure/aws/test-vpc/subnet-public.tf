
resource "aws_subnet" "public" {

  vpc_id = aws_vpc.primary.id

  cidr_block = var.public-subnet-cidr

  map_public_ip_on_launch = true

  tags = merge(var.tag-map, map("Name", "${var.env-key} public","tf-resource", "aws_subnet.public"))


}
