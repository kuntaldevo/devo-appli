
variable "region-id" {
  type = "string"
  default = "eastus"
  description = "The Azure Location"
}

#Standard Tags that are placed on ALL resources that except Tags

variable "cluster-id" {
  type = "string"
  description = "Identifies the cluster which is a grouping of servers and their configuration."
}

variable "tf-config" {
  type = "string"
  description = "Distinguishes environments within the same cluster."
}

variable "public-domain"
{


}

variable "customer-id"
{


}
