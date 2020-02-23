
variable "public-domain" {}

### Get the Existing & Public Route 53 provider ID
###This data source allows to find a Hosted Zone ID given Hosted Zone name and certain search criteria.
data "aws_route53_zone" "public" {
  name = var.public-domain
}


### Expose the UI to the world
resource "aws_route53_record" "public" {

  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name    = "metrics"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.instana-proxy.public_ip}"]
}
