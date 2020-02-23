

resource "null_resource" "destroy-tf-user" {

###Note: Since adding the user is manual, I will not automatically delete the user
### but I will delete the terraform user

  provisioner "local-exec" {
    when = "destroy"
    command = "kubectl config unset users.${var.env-key}-tf"
    on_failure = "continue"
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "kubectl config delete-context ${var.env-key}-tf"
    on_failure = "continue"
  }

}
