

resource "aws_vpc_peering_connection" "eks" {

  peer_vpc_id   = "vpc-47863e2f"

  vpc_id        = aws_vpc.eks.id

  auto_accept   = "true"

  tags = merge(var.tag-map, map("Name", var.env-key, "tf-resource", "aws_vpc_peering_connection.eks"))


}
