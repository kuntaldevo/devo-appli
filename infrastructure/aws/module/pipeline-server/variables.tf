
variable "cluster-size" { default = 3}


variable "subnet-id" {}
variable "security-group-id" {
  type = list
}

variable iam-profile { default = "" }
variable "server-ami" {}
variable "instance-type" {}
variable "volume-size" {}

variable "user-data" {
  type = list
  default = []
  description = "List of user data JSON objects for each mongo instance"
}


variable "tag-map" { type = map }

variable "depends-on" {
  type = list
  default = []
  description = "Terraform modules don't have dependency ordering for modules.  Create an un-used variable that will be set from a value from another resource"
}

#Route 53
variable "private-zone-id" {}

locals {

  env-key = lookup(var.tag-map, "env-key")

}
