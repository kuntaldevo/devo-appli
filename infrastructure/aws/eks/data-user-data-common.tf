

# User Data is getting more complex.  Create a common for basic things that ALL k8s nodes require

data "template_file" "user-data-common" {

  template = file("user-data-common.template")

  vars = {
  }
}
