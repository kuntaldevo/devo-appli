
resource "aws_vpc" "vpc" {

    cidr_block = var.vpc-cidr

### Must have both of these enabled for a private hosted zone
    enable_dns_support  = true
    enable_dns_hostnames   = true

    tags = merge(var.tag-map, map("Name", "${local.env-key} vpc","tf-resource", "aws_vpc.vpc"))

}
