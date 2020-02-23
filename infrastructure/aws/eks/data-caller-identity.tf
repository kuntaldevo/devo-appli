

data "aws_caller_identity" "current" {
  # no arguments
}

locals {

  account-id = data.aws_caller_identity.current.account_id

}
