
locals {

### https://www.terraform.io/upgrade-guides/0-11.html#referencing-attributes-from-resources-with-count-0
  pipeline-server-iam-profile-id = "${element(concat(aws_iam_instance_profile.pipeline-server.*.id, list("")), 0)}"

  pipeline-server-iam-profile = "${var.feature-ddl && var.feature-library == "s3" ? local.pipeline-server-iam-profile-id : "" }"

}


module "pipeline-server" {

  source = "../module/pipeline-server"

  #TODO Fix this to be the private subnet, which I already did but test it again
  #
  subnet-id = module.vpc.public-subnet-id
  security-group-id = ["${aws_security_group.private.id}"]

  server-ami = "${var.pipeline-server-ami}"
  instance-type = "${var.pipeline-server-instance-type}"
  volume-size = "${var.pipeline-server-volume-size}"

  iam-profile = "${local.pipeline-server-iam-profile}"

  user-data = "${module.pipeline-server-user-data.user-data}"

  # Tag Vars
  tag-map = var.tag-map

  #Route 53 Vars
  private-zone-id = "${aws_route53_zone.private.zone_id}"

  depends-on = ["module.spark-master.id"]

}
