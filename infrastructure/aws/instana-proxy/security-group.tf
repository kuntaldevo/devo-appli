resource "aws_security_group" "instana-proxy" {

  vpc_id = module.vpc.id

  name = "ext-instana-proxy"

  tags = merge(var.tag-map, map("Name", "${var.env-key} instana-proxy whitelist","tf-resource", "aws_security_group.instana-proxy"))

}
