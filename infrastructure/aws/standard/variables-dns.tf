###
###  Networking
###
variable "public-domain" {
  type = string
  description = "The Domain suffix for DNS entires that will be publicly accessible"
}


variable "private-domain" {
  type = string
  description = "The Domain suffix for DNS entires that are within the private DNS zone"
  default = "private.vpc"
}
