### Get the Existing & Public Route 53 provider ID
###This data source allows to find a Hosted Zone ID given Hosted Zone name and certain search criteria.
data "aws_route53_zone" "public" {

  name = var.public-domain

}

data "aws_route53_zone" "private" {

  name = var.private-domain

  private_zone = true
}
