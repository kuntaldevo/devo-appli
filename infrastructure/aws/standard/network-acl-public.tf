
resource "aws_network_acl" "public" {

  vpc_id = module.vpc.id

  subnet_ids = [module.vpc.public-subnet-id]

  tags = merge(var.tag-map, map("Name", "${var.env-key} public","tf-resource", "aws_network_acl.public"))

}


###
# Leave this open and allow the SG to protect
###
module "acl-public" {

  source = "../module/network-acl-rules"

  nacl-id = aws_network_acl.public.id

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
