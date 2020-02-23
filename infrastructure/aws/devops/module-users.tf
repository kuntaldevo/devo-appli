
module "users" {

  source = "./users"

  tag-map = var.tag-map
  account-id = var.account-id
  region-id = var.region-id

  depends-on-policies = module.policies.done-flag

}
