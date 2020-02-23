
variable "full-subnet-cidr" {
  type = "string"
  default = "198.162.0.0/16"
}

variable "public-subnet-cidr" {
  type = "string"
  default = "198.162.1.0/24"
}

variable "private-subnet-cidr" {
  type = "string"
  default = "198.162.2.0/24"
}
