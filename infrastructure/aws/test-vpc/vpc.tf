

resource "aws_vpc" "primary" {

    cidr_block = var.full-subnet-cidr

    tags = merge(var.tag-map, map("Name", "${var.env-key} vpc","tf-resource", "aws_vpc.primary"))

}
