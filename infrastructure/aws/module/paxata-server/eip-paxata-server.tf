resource "aws_eip" "paxata-server" {

  vpc      = true

  instance = aws_instance.paxata-server.id

  tags = merge(var.tag-map, map("tf-resource", "aws_eip.paxata-server"))

}
