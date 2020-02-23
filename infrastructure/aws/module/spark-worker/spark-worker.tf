
# Generate each specific User data by using a template file
data "template_file" "user-data" {

template = file("user-data/cluster.tpl")

  vars {
    instance-id = "0"
    host-name = "spark-worker"
  }
}


resource "aws_instance" "spark-worker" {

  ami                         = var.server-ami
  instance_type               = var.instance-type
  associate_public_ip_address = false
  ebs_optimized               = false
  subnet_id                   = var.subnet-id

  vpc_security_group_ids = [ var.security-group-ids ]

  iam_instance_profile        = var.iam-profile

  user_data     = data.template_file.user-data.rendered

  root_block_device {
    volume_size  = var.spark-worker-volume-size
  }

  tags = merge(var.tag-map, map( "tf-resource", "aws_instance.spark-worker", "Name", "${local.name} spark-worker-${count.index}"))

}

resource "aws_route53_record" "spark-worker-private" {
  zone_id = var.private-zone-id
  name    = "spark-worker-0"
  type    = "A"
  ttl     = "300"
  records = [ aws_instance.spark-worker.private_ip ]
}
