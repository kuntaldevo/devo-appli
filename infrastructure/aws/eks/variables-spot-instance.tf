

variable "default-spot-price" { }

variable "general-spot-price" {
  default = ""
}

variable "mongo-spot-price" {
  default = ""
}

variable "spark-spot-price" {
  default = ""
}


locals {

  general-spot-price = "${ ( var.general-spot-price == "" ? var.default-spot-price : var.general-spot-price )}"
  mongo-spot-price = "${ ( var.mongo-spot-price == "" ? var.default-spot-price : var.mongo-spot-price )}"
  spark-spot-price = "${ ( var.spark-spot-price == "" ? var.default-spot-price : var.spark-spot-price )}"

}
