
resource "aws_route_table" "private" {
    vpc_id = module.vpc.id

    tags = merge(var.tag-map, map("Name", "${var.env-key} private","tf-resource", "aws_route_table.private"))

}

resource "aws_route" "private-route" {

	route_table_id  = aws_route_table.private.id

	destination_cidr_block = "0.0.0.0/0"

	nat_gateway_id = aws_nat_gateway.nat.id
}
