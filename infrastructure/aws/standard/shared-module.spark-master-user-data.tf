
module spark-master-user-data {

  source = "../../shared-module/user-data"

  tag-map = var.tag-map

  server-role = "spark-master"
  host-name = "spark-master"
}
