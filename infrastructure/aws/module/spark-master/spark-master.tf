
resource "aws_instance" "spark-master" {

  ami                         = var.server-ami
  instance_type               = var.instance-type
  ebs_optimized               = false
  subnet_id                   = var.subnet-id
  vpc_security_group_ids      = var.security-group-id

  iam_instance_profile        = var.iam-profile

# There's only ever one spark master so assume there is only one user-data in the list
  user_data     = element(var.user-data, 0)

  root_block_device {
    volume_size  = var.volume-size
  }

  tags = merge(var.tag-map, map("Name", "${local.env-key} spark-master","tf-resource", "aws_instance.spark-master"))

}

resource "aws_route53_record" "spark-master-private" {

  zone_id = var.private-zone-id
  name    = "spark-master"
  type    = "A"
  ttl     = "300"
  records = [ aws_instance.spark-master.private_ip ]
}
