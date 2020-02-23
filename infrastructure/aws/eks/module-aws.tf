


module "aws" {

  source = "../module/aws"

  current-account = local.account-id
}
