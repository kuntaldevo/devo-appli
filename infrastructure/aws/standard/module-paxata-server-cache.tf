


module "paxata-server-cache" {

  source = "../module/ebs-volume"

  instance-count = "1"
  volume-count = "1"
  volume-label = ["xvdf"]

  #Pass in the Zone and the instance Ids create and attach the volumes
  zone = ["${module.paxata-server.availability-zone}"]
  instance-id = ["${module.paxata-server.id}"]

  type = "gp2"
  size = 100
  iops = 9000

  # Tag Vars
  tag-map = var.tag-map

}
