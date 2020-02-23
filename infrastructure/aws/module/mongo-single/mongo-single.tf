
variable "subnet-id" {}
variable "security-group-id" {}

variable "server-ami" {}
variable "instance-type" {}

variable "mongo-server-volume-size" {}

#Tag Vars
variable "tag-map" {type="map"}


#Route 53
variable "private-zone-id" {}


# Generate each specific User data by using a template file
data "template_file" "user-data" {

  count = "${var.cluster-size}"

  template = "${file("user-data/init.tpl")}"

  vars {
    instance-id = "0"
    host-name = "mongo-server"
  }
}


resource "aws_instance" "mongo-server" {

  ami                         = var.server-ami
  instance_type               = var.instance-type
  associate_public_ip_address = false
  ebs_optimized               = false
  subnet_id                   = var.subnet-id
  user_data     = data.template_file.user-data.rendered

  root_block_device {
    volume_size = var.mongo-server-volume-size
  }

  vpc_security_group_ids = ["${var.security-group-id}"]

  tags = var.tag-map

}

resource "aws_route53_record" "mongo-server-private" {
  zone_id = var.private-zone-id
  name    = "mongo-server"
  type    = "A"
  ttl     = "300"
  records = [ aws_instance.mongo-server.private_ip ]
}
