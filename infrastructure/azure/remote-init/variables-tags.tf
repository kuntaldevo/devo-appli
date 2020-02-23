
### Application Identification and Description variables


variable "customer-id" {
  type = "string"
  description = "identify the owner"
}


variable "cluster-id" {
  type = "string"
  description = "Identify the environment"
}

variable "tf-config" {
  type = "string"
  description = "This is an Id that distinguishes environments."
}

# for AWS this must be lowercase
variable "env-key" {

  type = "string"

  description = "The Project-Key with the Env appended."

  #No Default. External process is required to set this. I want an error or block if this is not set.
}

###
### SCM Details
###

variable "scm-sha" {

  type = "string"

  description = "The SHA or Release-Id of the source code branch the environment is being executed from"
}

variable "scm-branch" {

  type = "string"

  description = "The Branch of the source code environment is being executed from"
}

variable "scm-user" {

 type = "string"

  description = "The User that is registered with the source code environment is being executed from"
}

variable "scm-email" {

  type = "string"

  description = "The E-mail that is registered with the source code environment is being executed from"
}


###
### Exec Shell Details
###

variable "create-user" {

  type = "string"

  description = "The logged in user that ran this command"
}

variable "create-timestamp" {

  type = "string"

  description = "The date & time of the shell execution"
}

###
### Approver and Expiration tags
variable "approver" {

  type = "string"

  description = "The primary contact person regarding this regions management & cost"
}

variable "expiration" {

  type = "string"

  description = "A Date that is expected when this region will no longer be required and be terminated"
}

###Other variables that are used multiple places but will typically not be changed, ever

variable "audit-id" {
  type = "string"
  default = "audit"
  description = "The name of the audit region."
}
