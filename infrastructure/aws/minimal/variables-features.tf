
variable "feature-library" {

  type = string
  default = "local"

  description = "[local | s3]; When set to s3 the proper ACL is generated & the core-site.xml is distributed"
}

variable "feature-ddl" {

  default = true

  description = "When set to true the proper ACL is generated & the core-site.xml is distributed"

}


variable "hdfs-host" {
  type = string
  default = "local"
}
