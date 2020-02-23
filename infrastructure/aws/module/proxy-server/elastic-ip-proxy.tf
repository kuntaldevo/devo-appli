resource "aws_eip" "proxy" {

  vpc      = true

  tags = merge(var.tag-map, map("tf-resource", "aws_eip.proxy"))

}

resource "aws_eip_association" "proxy" {

  instance_id   = aws_instance.proxy-server.id

  allocation_id = aws_eip.proxy.id

  # Tags N/A
}
