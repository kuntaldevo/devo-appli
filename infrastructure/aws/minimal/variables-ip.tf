

variable "paxata-office-cidr-map" {

  type = list(map(string))

  description = "A List of IPs we typically White List."
}


variable "wfh-ip" {

  type = string
  default = ""
  description = "An Additional IP to use if passed into Terraform."
}
