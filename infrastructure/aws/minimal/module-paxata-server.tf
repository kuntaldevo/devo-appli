
module "paxata-server" {

  source = "../module/paxata-server"

  subnet-id = module.vpc.public-subnet-id
  security-group-id  = [aws_security_group.vpc.id]

  server-ami = data.aws_ami.paxata-server.id
  instance-type = var.paxata-server-instance-type
  volume-size = var.paxata-server-volume-size

  user-data = module.paxata-server-user-data.user-data

  iam-profile = aws_iam_instance_profile.paxata-server.id

  # Tag Vars
  tag-map = var.tag-map

  #Route 53 Vars
  public-zone-id = data.aws_route53_zone.private.zone_id
  vpc-zone-id = aws_route53_zone.vpc-zone.zone_id


  # The Paxata Server will not start without a running and available mongo
  # Added IG as recommendation from terraform docs
  depends-on = ["module.mongo-single","aws_internet_gateway.primary"]

}
