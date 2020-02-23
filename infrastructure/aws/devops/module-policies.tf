
module "policies" {

  source = "./policies"

  tag-map = var.tag-map
  account-id = var.account-id
  region-id = var.region-id

}
