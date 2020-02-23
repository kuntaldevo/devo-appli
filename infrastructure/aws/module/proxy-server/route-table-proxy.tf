
# Associate Proxy subnet to public route table
resource "aws_route_table_association" "proxy" {

    subnet_id = "${aws_subnet.proxy.id}"

    route_table_id = "${aws_route_table.proxy.id}"

# Tags N/A
}
