
resource "aws_instance" "paxata-server" {

  ami                         = var.server-ami
  instance_type               = var.instance-type
  subnet_id                   = var.subnet-id

  vpc_security_group_ids = var.security-group-id

  iam_instance_profile        = var.iam-profile

# Assume there is always a single Paxata Server
  user_data     = element(var.user-data, 0)

  root_block_device {
    volume_size    = var.volume-size
  }

  tags = merge(var.tag-map, map("Name", "${local.env-key} paxata-server","tf-resource", "aws_instance.paxata-server"))

}

### Expose the UI to the world
resource "aws_route53_record" "paxata_server_public" {
  zone_id = var.public-zone-id
  name    = local.env-key
  type    = "A"
  ttl     = "300"
  records = [aws_eip.paxata-server.public_ip]
}

resource "aws_route53_record" "paxata-server-vpc" {
  zone_id = var.vpc-zone-id
  name    = "paxata-server"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.paxata-server.private_ip]
}
