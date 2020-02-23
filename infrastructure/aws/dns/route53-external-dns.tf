


resource "aws_route53_record" "endpoint-public-dns" {


  count = "${length( var.test_list)}"

  zone_id = "Z2IXRU5PNR1FI1"
  name    = "${lookup(var.test_list[count.index], "name")}"
  type    = "${lookup(var.test_list[count.index], "type")}"
  ttl     = "300"
  records = ["${lookup(var.test_list[count.index], "content")}"]

#Tags N/A
}
