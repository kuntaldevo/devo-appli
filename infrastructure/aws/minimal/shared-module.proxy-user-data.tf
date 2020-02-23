
module proxy-user-data {
  source = "../../shared-module/user-data"

  tag-map = var.tag-map

  server-role = "proxy-server"
  host-name = "proxy-server"
  public-domain = var.private-domain
}
