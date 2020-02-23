

locals {

  env-key = lookup(var.tag-map, "env-key")

  region-id = "${lookup(var.tag-map, "region-id") }"
}
