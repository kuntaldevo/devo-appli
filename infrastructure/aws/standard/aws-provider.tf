
provider "aws" {

  region = var.region-id

  shared_credentials_file = "~/.aws/credentials"

  profile = var.profile-id
}
