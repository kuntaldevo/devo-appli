
locals {

  spark-worker-iam-profile-id = "${element(concat(aws_iam_instance_profile.spark-worker.*.id, list("")), 0)}"

  spark-worker-iam-profile = "${var.feature-ddl && var.feature-library == "s3" ? local.spark-worker-iam-profile-id : "" }"

}


module "spark-worker" {
  source = "../module/spark-worker-cluster"

  total-workers  = var.spark-worker-count

  subnet-id = module.vpc.public-subnet-id
  security-group-ids = ["${aws_security_group.private.id}"]

  server-ami = "${var.spark-worker-ami}"
  instance-type = var.spark-worker-instance-type
  volume-size = var.spark-worker-volume-size

  iam-profile = "${local.spark-worker-iam-profile}"

  user-data = ["${module.spark-user-data.user-data}"]

  # Tag Vars
  tag-map = var.tag-map

  #Route 53 Vars
  private-zone-id = "${aws_route53_zone.private.zone_id}"

  #Trick Terraform to use a Spark Master Dependency requiring the Spark Master to be available first.
  depends-on = "${module.spark-master.id}"

}
