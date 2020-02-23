

data "template_file" "config-map-aws-auth" {

  template = file("config-map-aws-auth.template")

  vars = {
    role-arn = local.worker-node-role-arn
  }

}
