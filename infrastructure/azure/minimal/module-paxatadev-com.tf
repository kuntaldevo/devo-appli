

variable "aws-profile-id" {}
variable "aws-region-id" {}

provider "aws" {

  region = "${var.aws-region-id}"

  shared_credentials_file = "~/.aws/credentials"

  profile = "${var.aws-profile-id}"
}

module "paxatadev" {

  source = "../module/paxatadev"

  public-domain = var.public-domain
  public-ip = "${azurerm_public_ip.default.ip_address}"
  public-url = "${var.cluster-id}.${var.customer-id}"

  tf-config = "${var.tf-config}"
  cluster-id = "${var.cluster-id}"
}
