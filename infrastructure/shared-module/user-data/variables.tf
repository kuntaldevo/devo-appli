

variable "total-instances" {

  default = "1"

}

variable tag-map {
  type = map
}

variable "public-domain" {

  type = string
  default = ""
  description = "The internet domain of this server, either paxata.com or paxatadev.com"
}


variable "server-role" {}

variable "host-name" {}

variable "volume-labels" {

  type = list
  default = []

}

variable "template-file" {

  type = string
  default = "common.template"
}

variable "domain-suffix" {

  type = string
  default = "private.vpc"
}

variable "feature-library" {

  type = string
  default = ""
}

variable "feature-ddl" {

  type = string
  default = ""
}

variable "hdfs-host" {

  type = string
  default = ""
}

variable "instana-api-key" {

  type = string
  default = ""
}
