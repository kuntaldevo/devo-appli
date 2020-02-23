
module paxata-server-user-data {

  source = "../../shared-module/user-data"

  tag-map = var.tag-map

  template-file = "paxata-server.template"
  server-role = "paxata-server"
  host-name = "paxata-server"
  feature-library = var.feature-library
  feature-ddl = "${var.feature-ddl}"
  hdfs-host = var.hdfs-host
  volume-labels = ["xvdf"]
  public-domain = var.private-domain

}
