resource "aws_instance" "proxy-server" {

  ami           = var.proxy-server-ami

# Must be a type that has ephemeral available (t2 does not)
  instance_type = "t2.small"

# The Region's Key name to use to allow SSH
  key_name   = var.aws-key-pair

# The Subnet to put the instance into
  subnet_id = aws_subnet.proxy.id

  vpc_security_group_ids      = [ aws_security_group.proxy.id ]

  user_data     = element(var.user-data, count.index)

  tags = merge(var.tag-map, map("tf-resource", "aws_instance.proxy-server"))

}
