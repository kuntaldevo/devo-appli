
locals {

### https://www.terraform.io/upgrade-guides/0-11.html#referencing-attributes-from-resources-with-count-0
  paxata-server-iam-profile-id = "${element(concat(aws_iam_instance_profile.paxata-server.*.id, list("")), 0)}"

  paxata-server-iam-profile = "${var.feature-library == "s3" ? local.paxata-server-iam-profile-id : "" }"

}

module "paxata-server" {

  source = "../module/paxata-server"

  subnet-id = module.vpc.public-subnet-id
  security-group-id  = ["${aws_security_group.paxata-server.id}"]

  server-ami = "${var.paxata-server-ami}"

  iam-profile = aws_iam_instance_profile.paxata-server.id

  instance-type = "${var.paxata-server-instance-type}"
  volume-size = "${var.paxata-server-volume-size}"

  user-data = "${module.paxata-server-user-data.user-data}"

  # Tag Vars
  tag-map = var.tag-map

  #Route 53 Vars
  vpc-zone-id = "${aws_route53_zone.private.zone_id}"
  public-zone-id = "${data.aws_route53_zone.public.zone_id}"


  # The Paxata Server will not start without a running and available mongo
  # Added IG as recommendation from terraform docs
  depends-on = ["module.mongo-single","module.vpc"]

}
