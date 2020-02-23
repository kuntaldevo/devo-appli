
module "instana-user-data"
{
  source = "../../shared-module/user-data"

  tag-map = var.tag-map

  server-role = "instana-monitor"
  host-name = "paxata-instana"
}
