
# Associate Public subnet to public route table
resource "aws_route_table_association" "public" {

  subnet_id = module.vpc.public-subnet-id

  route_table_id = "${module.vpc.main-route-table-id}"
}

# Associate Private subnet to private route table
resource "aws_route_table_association" "private" {

  subnet_id = "${module.vpc.private-subnet-id}"

  route_table_id = aws_route_table.private.id
}
