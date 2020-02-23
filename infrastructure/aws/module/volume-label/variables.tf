

variable "volume-total" {

  description = "The number of volumes that each instance will receive for it's cache / raid"
}

variable "labels-ebs" {

  default = ["xvdf","xvdg","xvdh","xvdi","xvdj","xvdk","xvdl","xvdm","xvdn","xvdo","xvdp"]

}

variable "create" {
  default = false
}
