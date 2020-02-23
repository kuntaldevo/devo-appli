resource "aws_nat_gateway" "nat" {

    allocation_id = aws_eip.nat.id

    subnet_id = module.vpc.public-subnet-id

    depends_on = ["module.vpc"]

    tags = merge(var.tag-map, map("Name", "${var.env-key} nat-gateway","tf-resource", "aws_nat_gateway.nat"))

}
