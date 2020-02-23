
output "cluster-public-url" {
     value = module.paxata-server.fqdn
}

output "ssh-command" {

  value = "ssh -i ~/.ssh/${var.aws-key-pair}.pem centos@${aws_route53_record.proxy-server-private.fqdn}"

}

output "spark-master-public-ip" {

  value = "${module.spark-master.public-ip}:8080"

}

output "pipeline-public-ip" {

  value = "${module.pipeline-server.public-ip}:4040"

}

output "paxata-ui-public-ip" {
   value = module.paxata-server.public-ip
}
