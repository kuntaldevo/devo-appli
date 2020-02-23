

data "aws_vpcs" "found" {

  tags = {
    role-id = "auto-eks"
  }
}


locals {

  found-vpc-id = element(concat(flatten( data.aws_vpcs.found.*.ids), list("")), 0)

}
