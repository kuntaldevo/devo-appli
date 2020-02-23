

# Find availablity zones for the subnets to use
data "aws_availability_zones" "available" {}


locals {
# Create the tag maps,
# Then because we are using a conditional in the aws_subnet tags we have to convert them to strings
#
  subnet-tags = merge(var.tag-map, map("Name", var.env-key, "role-id", "auto-eks", "kubernetes.io/cluster/${var.env-key}", "shared", "tf-resource", "aws_subnet.eks"))

#Convert the keys and values into comma delimited strings
  subnet-keys = join( ",", keys( local.subnet-tags ) )
  subnet-values = join( ",", values( local.subnet-tags ) )


  mongo-subnet-tags = merge(local.subnet-tags, map("server-id", "mongo-server"))
#Convert the keys and values into comma delimited strings
  mongo-subnet-keys = join( ",", keys( local.mongo-subnet-tags ) )
  mongo-subnet-values = join( ",", values( local.mongo-subnet-tags ) )

}

resource "aws_subnet" "eks" {

  count = length( data.aws_availability_zones.available.names )

  availability_zone = data.aws_availability_zones.available.names[count.index]

  cidr_block = cidrsubnet("10.169.0.0/16", 3, count.index )

  vpc_id            = aws_vpc.eks.id

#Conditional doesn't allow lists or maps, so use the comma delimited strings and then use zip map
  tags = "${ zipmap(
    split(",", count.index == 0 ? local.mongo-subnet-keys : local.subnet-keys ),
    split(",", count.index == 0 ? local.mongo-subnet-values :  local.subnet-values ) ) }"

}
