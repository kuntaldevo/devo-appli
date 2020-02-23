
module "mongo-single" {

  source = "../module/mongo-cluster"

  instance-count  = var.mongo-server-count

  subnet-id = module.vpc.public-subnet-id
  security-group-id = [ aws_security_group.vpc.id ]

  server-ami = data.aws_ami.mongo-server.id

  instance-type = var.mongo-server-instance-type
  volume-size = var.mongo-server-volume-size

  user-data = module.mongo-user-data.user-data

  # Tag Vars
  tag-map = var.tag-map

  #Route 53 Vars
  private-zone-id = aws_route53_zone.vpc-zone.zone_id

}
