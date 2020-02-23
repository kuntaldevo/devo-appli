
module paxata-server-user-data {

  source = "../../shared-module/user-data"

  tag-map = var.tag-map

  server-role = "paxata-server"

  feature-library = var.feature-library
  feature-ddl = var.feature-ddl

  template-file = "paxata-server.template"
  host-name = "paxata-server"
  volume-labels = ["xvdf"]
  hdfs-host = var.hdfs-host
  public-domain = var.private-domain

}
