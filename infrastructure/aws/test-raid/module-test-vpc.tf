
module "vpc"
{
  source = "../test-vpc"

  profile-id = var.profile-id

  region-id = var.region-id

  env-key = var.env-key

  tag-map = var.tag-map

}
