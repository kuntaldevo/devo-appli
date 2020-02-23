

variable "tag-map" {

  type = map

  description = "A Pre-generated Map of all the Tags to set"

  #No Default. External process is required to set this. I want an error or block if this is not set.
}

variable "library-name" {

  type = string

  description = "The name to set the library to"

  #No Default. External process is required to set this. I want an error or block if this is not set.
}

locals {

  env-key = lookup(var.tag-map, "env-key")

}
