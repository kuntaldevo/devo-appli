variable "cluster-size" { default = 4}


variable "subnet-id" {}
variable "security-group-ids" { type = list }

variable "server-ami" {}
variable "instance-type" {}

variable iam-profile { default = "" }

variable "spark-worker-volume-size" {}

variable "tag-map" { type = map }

#Route 53
variable "private-zone-id" {}

variable "depends-on" {
  type = list
  default = []
  description = "Terraform modules don't have dependency ordering for modules.  Create an un-used variable that will be set from a value from another resource"
}

locals {

  name = lookup(var.tag-map, "env-key")

}
