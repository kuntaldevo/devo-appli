
output "public-url" {
   value = "${aws_route53_record.public.fqdn}"
}

output "aws-public-ip" {
   value = "${aws_eip.instana-proxy.public_ip}"
}

locals {

  private-url = "${element(concat(flatten( aws_route53_record.private.*.fqdn), list("")), 0)}"


}

output "private-url" {
   value = "${local.private-url}"
}


output "ssh-command" {

   value = "ssh -i ~/.ssh/${var.aws-key-pair}.pem centos@${local.private-url}"

}

### Debug AWS module

output "is-not-production" {
   value = "${module.aws.is-not-production}"
}
output "not-production" {
   value = "${module.aws.not-production}"
}

output "production" {
   value = "${module.aws.production}"
}

output "is-production" {
   value = "${module.aws.is-production}"
}

output "current-account" {
   value = "${module.aws.current-account}"
}
