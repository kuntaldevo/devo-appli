
module "spark-worker" {
  source = "../module/spark-worker-cluster"

  total-workers  = var.spark-worker-count

  subnet-id = module.vpc.public-subnet-id
  security-group-ids = [ aws_security_group.vpc.id ]

  server-ami = data.aws_ami.spark-worker.id

  iam-profile = aws_iam_instance_profile.paxata-server.id
  instance-type = var.spark-worker-instance-type
  volume-size = var.spark-worker-volume-size

  user-data = module.spark-user-data.user-data

  # Tag Vars
  tag-map = var.tag-map

  #Route 53 Vars
  private-zone-id = aws_route53_zone.vpc-zone.zone_id

  #Trick Terraform to use a Spark Master Dependency requiring the Spark Master to be available first.
  depends-on = [ module.spark-master.id ]

}
