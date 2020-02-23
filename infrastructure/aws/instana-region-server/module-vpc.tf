
module "vpc" {
  source = "../module/vpc"

  tag-map = var.tag-map

}
