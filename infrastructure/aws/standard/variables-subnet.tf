
variable "full-subnet-cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public-subnet-cidr" {
  type = string
  default = "10.0.1.0/24"
}

variable "private-subnet-cidr" {
  type = string
  default = "10.0.2.0/24"
}

variable "devops-subnet-cidr" {
  type = string
  default = "10.0.4.0/24"
}

variable "excluded-availability-zones"
{
  type ="list"
  default = []
}
