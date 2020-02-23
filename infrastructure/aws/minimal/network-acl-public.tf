

resource "aws_network_acl" "public" {

  vpc_id = module.vpc.id

  subnet_ids = [module.vpc.public-subnet-id]

  ingress {
    rule_no    = 100
    protocol       = "-1"
    action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = 0
    to_port        = 0
  }


  egress{

    rule_no    = 100
    protocol   = -1
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(var.tag-map, map("Name", "${var.env-key} public","tf-resource", "aws_network_acl.public"))

}
