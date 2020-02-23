

resource "aws_instance" "mongo-server" {

  count = var.instance-count

  ami                         = var.server-ami
  instance_type               = var.instance-type
  subnet_id                   = var.subnet-id
  vpc_security_group_ids = var.security-group-id

  user_data     = element(var.user-data, count.index)

  root_block_device {
    volume_size = var.volume-size
  }

  tags = merge(var.tag-map, map( "tf-resource", "aws_instance.mongo-server", "Name", "${local.env-key} mongo-server-${count.index}"))

}

resource "aws_route53_record" "mongo-server-private" {

  count = var.instance-count

  zone_id = var.private-zone-id
  name    = "mongo-server-${count.index}"
  type    = "A"
  ttl     = "300"
  records = [ element(aws_instance.mongo-server.*.private_ip, count.index) ]
}
