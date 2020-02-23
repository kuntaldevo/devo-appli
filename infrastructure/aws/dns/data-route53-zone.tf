### Get the Existing & Public Route 53 provider ID
###This data source allows to find a Hosted Zone ID given Hosted Zone name and certain search criteria.
data "aws_route53_zone" "public" {
  name = "paxatadev.com"
}
