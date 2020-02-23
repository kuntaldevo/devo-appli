
module "spark-master" {

  source = "../module/spark-master"

  subnet-id = module.vpc.public-subnet-id
  security-group-id      = [ aws_security_group.vpc.id ]

  server-ami = data.aws_ami.spark-master.id

  iam-profile = aws_iam_instance_profile.paxata-server.id

  instance-type = var.spark-master-instance-type
  volume-size = var.spark-master-volume-size

  user-data = module.spark-master-user-data.user-data

  # Tag Vars
  tag-map = var.tag-map

  #Route 53 Vars
  private-zone-id = aws_route53_zone.vpc-zone.zone_id

}
