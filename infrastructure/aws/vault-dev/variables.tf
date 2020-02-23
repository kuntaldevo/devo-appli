

variable "address" {

  default = "vault.paxata.ninja"

}



variable tag-map {
  type =  map
}

variable paxata-domain {
  description = "The TLD to use"
}

variable aws-key-pair {}

variable env-key {
  description = "Not used. Placate TF 12"
}
variable account-id {
  description = "Not used. Placate TF 12"
}
variable profile-id {
  description = "Not used. Placate TF 12"
}
variable region-id {
  description = "Not used. Placate TF 12"
}
