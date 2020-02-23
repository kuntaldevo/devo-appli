### Create a route that will allow the internet gateway be able to direct traffic to the VPC

resource "aws_route_table" "proxy" {

    vpc_id = var.vpc-id

    tags = merge(var.tag-map, map("tf-resource", "aws_route_table.proxy"))
}

resource "aws_route" "proxy" {

  route_table_id  = aws_route_table.proxy.id

  gateway_id = var.internet-gateway-id

  destination_cidr_block = "0.0.0.0/0"

# Tags N/A
}
