


module "vpc" {

  source = "../module/vpc"

  # Override the Default VPC CIDR
  vpc-cidr = "${var.full-subnet-cidr}"
  public-cidr = "${var.public-subnet-cidr}"
  private-cidr = "${var.private-subnet-cidr}"


  availability-zone = "${module.availability-zone.selected}"



  # Tag Vars
  tag-map = var.tag-map

#TODO figure out how to filter subnets for certain instance types
#aws_instance.paxata-server: Error launching source instance: Unsupported: Your requested instance type (r3.2xlarge) is not supported in your requested Availability Zone (us-east-1f). Please retry your request by not specifying an Availability Zone or choosing us-east-1d, us-east-1a, us-east-1e, us-east-1c.
}
