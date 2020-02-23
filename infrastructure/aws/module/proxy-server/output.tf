

output "proxy-public-ip" {
   value = "${aws_eip.proxy.public_ip}"
}

output "nacl-id" {
  value = "${aws_network_acl.proxy.id}"
}

output "sg-id" {
  value = "${aws_security_group.proxy.id}"
}

output "fqdn" {
     value = "${aws_route53_record.proxy-public-dns.fqdn}"
}
