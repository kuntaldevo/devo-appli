###
### Gateway
resource "aws_internet_gateway" "primary" {

    vpc_id = aws_vpc.primary.id

    tags = merge(var.tag-map, map("Name", "${var.env-key} internet gateway","tf-resource", "aws_internet_gateway.primary"))

}
