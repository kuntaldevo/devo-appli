variable "tag-map" {

  type = map

  description = "A Pre-generated Map of all the Tags to set"

  #No Default. External process is required to set this. I want an error or block if this is not set.
}

variable "library-name" {

  type = string

  description = "The name of the library to allow access to via IAM Policy"

  #No Default. External process is required to set this. I want an error or block if this is not set.
}


variable "create-policy" {

  type = string

  description = "Enable/Disable this module based on this boolean flag"

  #No Default. External process is required to set this. I want an error or block if this is not set.
}

locals {

  env-key = lookup(var.tag-map, "env-key")

  region-id = lookup(var.tag-map, "region-id")

}
