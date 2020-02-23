
module "pipeline-server" {

  source = "../module/pipeline-server"

  subnet-id = module.vpc.public-subnet-id
  security-group-id  = [ aws_security_group.vpc.id ]

  server-ami = data.aws_ami.pipeline-server.id

  iam-profile = aws_iam_instance_profile.paxata-server.id

  instance-type = var.pipeline-server-instance-type
  volume-size = var.pipeline-server-volume-size

  user-data = module.pipeline-server-user-data.user-data

  # Tag Vars
  tag-map = var.tag-map

  #Route 53 Vars
  private-zone-id = aws_route53_zone.vpc-zone.zone_id

  depends-on = ["module.spark-master.id"]

}
