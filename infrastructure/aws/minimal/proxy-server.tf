
resource "aws_instance" "proxy-server" {

  ami                         =  data.aws_ami.proxy-server.id

  instance_type               = var.proxy-server-instance-type
  ebs_optimized               = false
  key_name                    = var.aws-key-pair
  subnet_id                   = module.vpc.public-subnet-id

  vpc_security_group_ids      = [ aws_security_group.vpc.id ]

# There shall always be a single proxy server
  user_data     = element(module.proxy-user-data.user-data, 0)

  tags = merge(var.tag-map, map("Name", "${var.env-key} proxy-server","tf-resource", "aws_instance.proxy-server"))

}

### Create Public IP for Proxy Server
resource "aws_route53_record" "proxy-server-private" {
  zone_id = data.aws_route53_zone.private.zone_id
  name    = "proxy-${var.env-key}"
  type    = "A"
  ttl     = "300"
  records = [ aws_instance.proxy-server.public_ip ]
}

resource "aws_route53_record" "proxy-server" {
  zone_id = aws_route53_zone.vpc-zone.zone_id
  name    = "proxy-server"
  type    = "A"
  ttl     = "300"
  records = [ aws_instance.proxy-server.private_ip ]
}
