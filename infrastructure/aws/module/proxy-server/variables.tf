
variable "vpc-id" {}
variable "subnet-cidr" {}
variable "aws-key-pair" {}
variable "internet-gateway-id" {}
variable "public-domain" {}
variable "private-zone-id" {}
variable "cidr-blocks" { type = list }

variable "tag-map" { type = map }

variable "proxy-server-ami" {}

variable "user-data" {
  type = list
  default = []
  description = "List of user data JSON objects for each mongo instance"
}
