
# Using the Access-Role variable create a YAML template of them to be added to the aws-auth file

data "template_file" "aws-auth-roles" {

  count = length( var.access-roles)

  template = file("aws-auth-role.template")
  vars = {
    role-arn = "arn:aws:iam::${local.account-id}:role/${lookup(var.access-roles[count.index], "role-arn" ) }"
    username = lookup(var.access-roles[count.index], "username" )
    group = lookup(var.access-roles[count.index], "group" )
  }
}
