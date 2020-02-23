
module "user-data"
{
  source = "../../shared-module/user-data"

  env-key = var.env-key
  region-id = var.region-id

  host-name = "single-server"
  volume-labels = ["xvdf", "xvdg"]

}
