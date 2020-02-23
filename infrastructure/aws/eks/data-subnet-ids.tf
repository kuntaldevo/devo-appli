
# This tag is used to get all subnets that should be added to the cluster automatically.
data "aws_subnet_ids" "all-cluster-subnets" {


  vpc_id = "${local.found-vpc-id}"


  tags = {
    eks-subnet = "true"
  }

}

# Subnets are further broken down into public and private.  We only want nodes in the private subnets
data "aws_subnet_ids" "node-subnets" {


  vpc_id = "${local.found-vpc-id}"

  tags = {
    eks-subnet = "true"
    eks-role = "worker-node"
  }

}

#data "aws_subnet_ids" "elb-subnets" {
#
#  vpc_id = "${local.found-vpc-id}"
#
#  tags = {
#    eks-subnet = "true"
#    eks-role = "public-elb"
#  }
#}


data "aws_subnet_ids" "mongo" {


 vpc_id = "${local.found-vpc-id}"

  tags = {
    eks-subnet = "true"
    server-id = "mongo-server"
  }
}
