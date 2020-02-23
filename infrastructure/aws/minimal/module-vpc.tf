


module "vpc" {

  source = "../module/vpc"

  # Tag Vars
  tag-map = var.tag-map

}
