#
# Outputs
#

output "config_map_aws_auth" {
  value = "\n\n\nFile Written to .kube/config-map-aws-auth.yml.  Terraform should have already applied the ConfigMap.\n\n\n"
}


locals {

  aws-auth-file = "${data.template_file.config-map-aws-auth.rendered}${join( "", data.template_file.aws-auth-roles.*.rendered ) }"
}


resource "local_file" "config_map_aws_auth" {
    content     = local.aws-auth-file
    filename = ".kube/config-map-aws-auth.yml"
}


# Apply the AWS permission to allow nodes to join the cluster
# Using the generated KUBECONFIG since there is a manual step for the user's default config
resource "null_resource" "aws-access" {

  count = var.do-eks

  triggers = {
     always = uuid()
  }

  provisioner "local-exec" {
    command = "kubectl apply -f .kube/config-map-aws-auth.yml"

    environment = {
      KUBECONFIG = ".kube/kubeconfig.yml"
    }
  }

  depends_on = [ local_file.kubeconfig, local_file.config_map_aws_auth ]

}
