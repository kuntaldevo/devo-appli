
variable "production-account-id" {

  default = ["365762923425", "752595142617" ]
}


variable "non-production-account-id" {

  default = "011447054295"
}


variable "current-account" {

  description = "Passed in, will set a few outputs to determine if the current-account is Production or otherwise."
}
