
resource "aws_network_acl" "private" {

  vpc_id = module.vpc.id

  subnet_ids = [ module.vpc.private-subnet-id ]

  tags = merge(var.tag-map, map("Name", "${var.env-key} private","tf-resource", "aws_network_acl.private"))

}

module "acl-private" {

  source = "../module/network-acl-rules"

  nacl-id = aws_network_acl.private.id

  ingress-cidr = [ var.full-subnet-cidr ]
  ingress-cidr = ["0.0.0.0/0"]

  ingress-rules = [
    {
      action = "allow"
      from-port   = -1
      to-port     = -1
      protocol    = "-1"
    }
  ]

  egress-cidr = ["0.0.0.0/0"]

  egress-rules = [
    {
      action = "allow"
      from-port   = -1
      to-port     = -1
      protocol    = "-1"
    }
  ]
}
