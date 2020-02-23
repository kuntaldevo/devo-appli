

# for AWS this must be lowercase
variable "env-key" {

  type = string

  description = "The Project-Key with the Env appended."

  #No Default. External process is required to set this. I want an error or block if this is not set.
}

variable "tag-map" {

  type = "map"

  #No Default. External process is required to set this. I want an error or block if this is not set.
}
