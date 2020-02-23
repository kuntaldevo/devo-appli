
### Application Identification and Description variables

variable "profile-id" {

  type = string

  description = "Using the systems's AWS credential file. Use this profile"
}

variable "region-id" {

  type = string

  description = "Using the systems's AWS credential file. Use this profile"
}

variable "account-id" {

  type = string

  description = "The Account Id of the AWS account.  Used to determine Dev or Prod"
}
