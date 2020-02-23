
variable "private-domain" {}

data "aws_route53_zone" "private" {

  count = "${module.aws.not-production}"

  name = var.private-domain

  private_zone = true

}

### Expose the UI to the world
resource "aws_route53_record" "private" {

  count = "${module.aws.not-production}"

  zone_id = "${data.aws_route53_zone.private.zone_id}"
  name    = "metrics"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.instana-proxy.public_ip}"]
}
