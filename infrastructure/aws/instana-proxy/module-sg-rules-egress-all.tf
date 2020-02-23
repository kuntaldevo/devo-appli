

module "sg-egress-all" {

  source = "../module/security-group-rules"

  sg-id       = "${aws_security_group.instana-proxy.id}"

  egress-rules = [
    {
      action = "allow"
      from-port   = -1
      to-port     = -1
      protocol    = "-1"
      description = "Egress All"
    }
  ]
}
