resource "aws_eip" "nat" {

  vpc      = true

  depends_on = ["module.vpc"]

  tags = merge(var.tag-map, map("tf-resource", "aws_eip.nat"))

}
