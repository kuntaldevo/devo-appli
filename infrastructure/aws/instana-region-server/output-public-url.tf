
output "internal-url" {
   value = "${aws_route53_record.maintenance.fqdn}"
}

output "aws-public-ip" {
   value = "${aws_instance.instana.public_ip}"
}

output "ssh-command" {

   value = "ssh -i ~/.ssh/${var.aws-key-pair}.pem centos@instana.${var.region-id}.${var.maintenance-domain}"

}
