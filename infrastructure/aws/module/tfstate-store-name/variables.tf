variable "library-name-prefix" {
  type = string
  default = "tfstate"
  description = "the prefix of the file store."
}

variable "library-name-suffix" {
  type = string
  default = "devops.paxata.com"
  description = "the suffix of the file store."
}

variable "tag-map" {

  type = map

  description = "A Pre-generated Map of all the Tags to set"

  #No Default. External process is required to set this. I want an error or block if this is not set.
}
