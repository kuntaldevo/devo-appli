
variable "vpc-cidr" {

  type = string
  default = "10.0.0.0/16"

}

variable "public-cidr" {

  type = string
  default = "10.0.0.0/24"

}

variable "private-cidr" {

  type = string
  default = "10.0.1.0/24"

}
