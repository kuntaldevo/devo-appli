


module "aws" {

  source = "../module/aws"

  current-account = var.account-id
}

variable "account-id" {}