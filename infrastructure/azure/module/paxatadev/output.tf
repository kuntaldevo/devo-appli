

output "ui-url"
{
value = "${var.public-url}.${data.aws_route53_zone.public.zone_id}"

}
