
variable "mongo-server-instance-type" {
  type = string
}

variable "mongo-server-volume-size" {
  type = string
}


variable "mongo-server-count" {
  type = string
  default = "3"
}