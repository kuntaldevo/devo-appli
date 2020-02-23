

variable "tag-map" {

  type = map

  description = "A Map of Key Values to use."

  #No Default. External process is required to set this. I want an error or block if this is not set.
}


locals {

  env-key = lookup(var.tag-map, "env-key")

}
