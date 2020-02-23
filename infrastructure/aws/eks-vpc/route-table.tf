

resource "aws_route_table" "eks" {

  vpc_id = "${aws_vpc.eks.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.eks.id}"
  }

}

resource "aws_route_table_association" "eks" {

  count = "${ length( data.aws_availability_zones.available.names ) }"

  subnet_id      = "${aws_subnet.eks.*.id[count.index]}"

  route_table_id = "${aws_route_table.eks.id}"
}
