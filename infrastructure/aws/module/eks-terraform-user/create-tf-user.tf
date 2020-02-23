


# Create a user to allow terraform to update the cluster
# Because there are inputs and outputs from commands that are used in later commands
# It's just easier to put it all into a Bash script
resource "null_resource" "create-terraform-user" {

  triggers = {
     always = "${ uuid() }"
  }

  provisioner "local-exec" {
    command = "bash create-terraform-user.bash"
  }

  depends_on = [
    "local_file.kubeconfig"
  ]
}
