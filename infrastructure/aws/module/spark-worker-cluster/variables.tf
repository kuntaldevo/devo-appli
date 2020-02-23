variable "total-workers" {}

variable "subnet-id" {}
variable "security-group-ids" { type = list }

variable "server-ami" {}
variable "instance-type" {}
variable "volume-size" {}
variable iam-profile { default = "" }


variable "user-data" {
  type = list
  default = []
  description = "The Pre-Generated User data"
}

#Route 53
variable "private-zone-id" {}

variable "depends-on" {
  type = list
  default = []
  description = "Terraform modules don't have dependency ordering for modules.  Create an un-used variable that will be set from a value from another resource"
}

variable "tag-map" { type = map }

locals {

  env-key = lookup(var.tag-map, "env-key")

}
