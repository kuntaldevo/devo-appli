

variable "access-roles" {

   default = []
   description = "A list of Maps that has additional roles add to aws-auth"

}

variable "access-users" {

   default = []
   description = "A list of Maps that has additional user to add to aws-auth"

}
