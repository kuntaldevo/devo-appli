
### IP addresses for Paxata physical offices
### Addresses of offices

variable "paxata-jumphost-cidr-map" {
  description = "a list where each element in the list is a Map.  Each Map contains keys 'cidr' and 'description' "
  type = list
}

variable "paxata-office-cidr-map" {
  description = "a list where each element in the list is a Map.  Each Map contains keys 'cidr' and 'description' "
  type = list
}

variable "customer-cidr-map" {

  type = list
  default = []

  description = "Provide a hook that can be defined explicitly for each customer where their IPs can be added"

}

variable "s3-cidr-map"
{
  type = list
}

variable "wfh-ip"
{
 default = ""
}
