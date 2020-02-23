
variable "maintenance-domain" {

  description="Maintain a URL that will point to the server for maintenance purposes."

}


data "aws_route53_zone" "maintenance" {

  name = "${var.maintenance-domain}"
#  private_zone = true

}

### Have a EIP that is available for server maintenance
### Generally this will be a public IP ( for sure in prod )
resource "aws_route53_record" "maintenance" {

  zone_id = "${data.aws_route53_zone.maintenance.zone_id}"
  name    = "instana.${var.region-id}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.proxy.public_ip}"]
}
