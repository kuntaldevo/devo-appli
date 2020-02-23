
module instana-user-data
{
  source = "../../shared-module/user-data"

  tag-map = var.tag-map

  server-role = "instana-proxy"
  host-name = "instana-proxy"
  public-domain = var.public-domain
  instana-api-key = "${var.instana-api-key}"
}
