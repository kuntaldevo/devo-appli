
resource "aws_instance" "spark-worker" {

  count = var.total-workers

  ami                         = var.server-ami
  instance_type               = var.instance-type
  subnet_id                   = var.subnet-id
  vpc_security_group_ids =  var.security-group-ids
  iam_instance_profile        = var.iam-profile

  user_data     = var.user-data[count.index]


  root_block_device {
    volume_size  = var.volume-size
  }

  ephemeral_block_device {
    device_name = "/dev/xvdf"
    virtual_name = "ephemeral0"
  }

  tags = merge(var.tag-map, map( "tf-resource", "aws_instance.spark-worker", "Name", "${local.env-key} spark-worker-${count.index}"))

}

resource "aws_route53_record" "spark-worker-private" {

  count = var.total-workers

  zone_id = var.private-zone-id
  name    = "spark-worker-${count.index}"
  type    = "A"
  ttl     = "300"
  records = [ element(aws_instance.spark-worker.*.private_ip, count.index) ]
}
