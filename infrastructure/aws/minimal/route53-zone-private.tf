
### Create a private zone for each VPC
### This appears to be required to allow maximum
### flexibility and total control over DNS naming within the VPC

resource "aws_route53_zone" "vpc-zone" {

  name = var.vpc-zone

  comment = "cluster: ${var.env-key}"

  vpc {
    vpc_id = module.vpc.id
  }

}

### Instruct DHCP to still use the Amazon to get to our private zone VPC
### Set the default search domain to match our private zone above
resource "aws_vpc_dhcp_options" "primary" {

  domain_name          = var.vpc-zone

  domain_name_servers  = ["AmazonProvidedDNS"]

  tags = merge(var.tag-map, map("Name", "${var.env-key} primary","tf-resource", "aws_vpc_dhcp_options.primary"))

}


resource "aws_vpc_dhcp_options_association" "dns_resolver" {

  vpc_id          = module.vpc.id

  dhcp_options_id = aws_vpc_dhcp_options.primary.id
}
