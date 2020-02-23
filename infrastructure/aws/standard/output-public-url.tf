
output "cluster-public-url" {
     value = module.paxata-server.fqdn
}

output "ui-public-ip" {
   value = module.paxata-server.public-ip
}

output "ssh-login" {

  value = "ssh -i ~/.ssh/${var.aws-key-pair}.pem centos@proxy-${var.env-key}.${var.public-domain}"
}
