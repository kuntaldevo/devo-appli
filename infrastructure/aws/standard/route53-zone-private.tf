
### Create a private zone for each VPC
### This appears to be required to allow maximum
### flexibility and total control over DNS naming within the VPC

resource "aws_route53_zone" "private" {

  name = var.private-domain

  vpc {
    vpc_id = module.vpc.id
  }

  comment = "cluster: ${var.env-key}"
}

### Instruct DHCP to still use the Amazon to get to our private zone VPC
### Set the default search domain to match our private zone above
resource "aws_vpc_dhcp_options" "private-vpc" {

  domain_name          = var.private-domain

  domain_name_servers  = ["AmazonProvidedDNS"]

  tags = merge(var.tag-map, map("Name", "${var.env-key} private-vpc","tf-resource", "aws_vpc_dhcp_options.private-vpc"))

}


resource "aws_vpc_dhcp_options_association" "dns_resolver" {

  vpc_id          = module.vpc.id

  dhcp_options_id = aws_vpc_dhcp_options.private-vpc.id
}
