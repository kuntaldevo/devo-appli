


resource "aws_vpc" "eks" {

  cidr_block = var.vpc-cidr

  tags = merge(var.tag-map, map("Name", var.env-key,"role-id", "auto-eks", "kubernetes.io/cluster/${var.env-key}", "shared", "tf-resource", "aws_vpc.eks"))

}


resource "aws_internet_gateway" "eks" {

  vpc_id = aws_vpc.eks.id

  tags = merge(var.tag-map, map("Name", var.env-key, "tf-resource", "aws_internet_gateway.eks"))

}
