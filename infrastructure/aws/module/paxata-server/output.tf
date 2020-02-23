
output "id" {
   value = "${aws_instance.paxata-server.id}"
}

output "public-ip" {
   value = "${aws_eip.paxata-server.public_ip}"
}

output "fqdn" {
     value = "${aws_route53_record.paxata_server_public.fqdn}"
}

output "availability-zone" {

   value = "${aws_instance.paxata-server.availability_zone}"
}
