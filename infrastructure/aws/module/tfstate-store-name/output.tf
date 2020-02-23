locals {

  env-key = lookup(var.tag-map, "env-key")

  region-id = lookup(var.tag-map, "region-id")

}



output "name" {

  value = "${var.library-name-prefix}.${local.env-key}.${local.region-id}.${var.library-name-suffix}"

}
