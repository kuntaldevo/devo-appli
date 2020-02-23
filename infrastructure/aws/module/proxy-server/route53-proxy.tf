

resource "aws_route53_record" "proxy-private-dns" {
  zone_id = var.private-zone-id
  name    = "proxy-server"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.proxy-server.private_ip}"]

  #Tags N/A

}


resource "aws_route53_record" "proxy-public-dns" {
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name    = "proxy-${lookup(var.tag-map,"env-key")}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.proxy.public_ip}"]

#Tags N/A
}
