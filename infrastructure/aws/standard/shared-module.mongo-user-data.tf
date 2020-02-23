
module mongo-user-data {

  source = "../../shared-module/user-data"

  total-instances = var.mongo-server-count

  tag-map = var.tag-map

  template-file = "mongo-server.template"
  server-role = "mongo-server"
  host-name = "mongo-server"
}
