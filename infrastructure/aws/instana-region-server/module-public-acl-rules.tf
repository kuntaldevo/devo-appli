
# Because the Server needs too many IPs that are permissible for an NACL We will leave this wide open
# and use the Security Group Instead

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

}
