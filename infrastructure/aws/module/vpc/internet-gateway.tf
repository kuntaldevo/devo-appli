###
### Gateway
resource "aws_internet_gateway" "ig" {

    vpc_id = aws_vpc.vpc.id

    tags = merge(var.tag-map, map("Name", "${local.env-key} internet gateway","tf-resource", "aws_internet_gateway.ig"))

}
