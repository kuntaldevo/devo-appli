
module "vpc" {
  source = "../module/single-public-server"

  env-key = var.env-key

  tag-map = var.tag-map

}
