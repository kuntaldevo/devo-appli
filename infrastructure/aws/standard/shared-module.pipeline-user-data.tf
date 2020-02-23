
module pipeline-server-user-data {

  source = "../../shared-module/user-data"

  tag-map = var.tag-map

  server-role = "pipeline-server"
  host-name = "pipeline-server"
  feature-library = var.feature-library
  feature-ddl = "${var.feature-ddl}"
  volume-labels = [""]
}
