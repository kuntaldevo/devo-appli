

data "aws_region" "current" {
  # no arguments
}

locals {

  region-id = data.aws_region.current.name
}
