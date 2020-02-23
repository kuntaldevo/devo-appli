


data "template_file" "pipeline-portal" {

  template = "${file("portal-pipeline.yml.template")}"

  vars = {
    env-key = var.env-key
    namespace = var.env-key
    domain-suffix = "${var.maintenance-domain}"
  }
}

# Put a copy of the KubeConfig in the local
resource "local_file" "pipeline-portal" {

  content     = "${data.template_file.pipeline-portal.rendered}"

  filename = ".kube/pipeline-portal.yml"
}
