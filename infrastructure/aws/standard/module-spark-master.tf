
module "spark-master" {

  source = "../module/spark-master"

  #TODO Fix this to be the private subnet, 
  subnet-id = module.vpc.public-subnet-id
  security-group-id = ["${aws_security_group.private.id}"]

  server-ami = "${var.spark-master-ami}"
  instance-type = "${var.spark-master-instance-type}"
  volume-size = "${var.spark-master-volume-size}"

  user-data = "${module.spark-master-user-data.user-data}"

  # Tag Vars
  tag-map = var.tag-map

  #Route 53 Vars
  private-zone-id = "${aws_route53_zone.private.zone_id}"

}
