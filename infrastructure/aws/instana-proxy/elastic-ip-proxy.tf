resource "aws_eip" "instana-proxy" {

  vpc      = true

  tags = merge(var.tag-map, map("tf-resource", "aws_eip.instana-proxy"))

}

resource "aws_eip_association" "instana-proxy" {

  instance_id   = aws_instance.instana-proxy.id

  allocation_id = aws_eip.instana-proxy.id

  # Tags N/A
}
