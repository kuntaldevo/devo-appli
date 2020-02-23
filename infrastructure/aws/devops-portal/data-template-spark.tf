


data "template_file" "spark-portal" {

  template = "${file("portal-spark.yml.template")}"

  vars = {
    env-key = var.env-key
    namespace = var.env-key
    domain-suffix = "${var.maintenance-domain}"
  }
}

# Put a copy of the KubeConfig in the local
resource "local_file" "spark-portal" {

  content     = "${data.template_file.spark-portal.rendered}"

  filename = ".kube/spark-portal.yml"
}
