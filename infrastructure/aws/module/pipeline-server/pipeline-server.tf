
resource "aws_instance" "pipeline-server" {

  ami                         = var.server-ami
  instance_type               = var.instance-type
  ebs_optimized               = false
  subnet_id                   = var.subnet-id

  iam_instance_profile        = var.iam-profile
  vpc_security_group_ids      = var.security-group-id

# Assume there is only one pipeline server
  user_data     = element(var.user-data, 0)

  root_block_device {
    volume_size   = var.volume-size
  }

  tags = merge(var.tag-map, map("Name", "${local.env-key} pipeline-server","tf-resource", "aws_instance.pipeline-server"))

}

resource "aws_route53_record" "pipeline-server-private" {

  zone_id = var.private-zone-id
  name    = "pipeline-server"
  type    = "A"
  ttl     = "300"
  records = [ aws_instance.pipeline-server.private_ip ]
}
