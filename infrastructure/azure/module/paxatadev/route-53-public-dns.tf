
variable "cluster-id" {}

variable "tf-config" {}

variable "public-ip" {}

variable "public-url" {}


### Expose the UI to the world
resource "aws_route53_record" "paxata_server_public" {
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name    = "${var.public-url}"
  type    = "A"
  ttl     = "300"
  records = ["${var.public-ip}"]
}
