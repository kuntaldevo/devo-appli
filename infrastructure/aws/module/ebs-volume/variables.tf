

variable "type" {}
variable "size" {}
variable "iops" {}

variable "instance-count" {

  description = "I wanted to use the length of the instance ID array but at 'plan time' the length is not available yet because the output is a list of calculated values.  For now we need to pass in the number of workers"

}

variable "volume-count" {

  description = "The Number of volumes to create for each instance"

}

variable "volume-label" {
  type = list
  description = "The list of volume names we are going to use"

}


variable "instance-id" {

  type = list
  description = "A list of the AMI instances to attach Volumes too"

}

variable "zone" {

  type = list
  description = "A list of the AMI instances corresponding 'zone' which is required to create volumes in the same zone as the instance"

}

variable "tag-map" { type = map }
