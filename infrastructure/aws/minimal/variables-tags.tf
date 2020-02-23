
### Application Identification and Description variables

variable "tag-map" {

  type = map

  #No Default. External process is required to set this. I want an error or block if this is not set.
}


# for AWS this must be lowercase
variable "env-key" {

  type = string

  description = "The Project-Key with the Env appended."

  #No Default. External process is required to set this. I want an error or block if this is not set.
}


###Other variables that are used multiple places but will typically not be changed, ever

variable "audit-id" {
  type = string
  default = "audit"
  description = "The name of the audit region."
}
