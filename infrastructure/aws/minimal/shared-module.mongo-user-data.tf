
module mongo-user-data {

  source = "../../shared-module/user-data"

  total-instances = var.mongo-server-count

  server-role = "mongo-server"

  tag-map = var.tag-map

  template-file = "mongo-server.template"
  host-name = "mongo-server"
}
