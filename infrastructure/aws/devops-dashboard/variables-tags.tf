
### Application Identification and Description variables

# for AWS the value must be lowercase
variable "env-key" {

  type = string

  description = "The Customer Id appended with the Cluster Id."

  #No Default. External process is required to set this. I want an error or block if this is not set.
}

#
variable "tag-map" {

  type = "map"

  description = "A Pre-generated Map of all the Tags to set"

  #No Default. External process is required to set this. I want an error or block if this is not set.
}
