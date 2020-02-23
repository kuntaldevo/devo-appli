### Create a route that will allow the internet gateway be able to direct traffic to the VPC

resource "aws_route" "public" {

  route_table_id  = aws_vpc.vpc.default_route_table_id

  gateway_id = aws_internet_gateway.ig.id

  destination_cidr_block = "0.0.0.0/0"

# Tags N/A
}
