


data "template_file" "dashboard-portal" {

  template = "${file("portal-dashboard.yml.template")}"

  vars = {
    env-key = var.env-key
    namespace = var.env-key
    domain-suffix = "${var.maintenance-domain}"
  }
}

# Put a copy of the KubeConfig in the local
resource "local_file" "dashboard-portal" {

  content     = "${data.template_file.dashboard-portal.rendered}"

  filename = ".kube/dashboard-portal.yml"
}


resource "null_resource" "apply-dashboard-portal" {

  triggers = {
     on-change = "${ md5(data.template_file.dashboard-portal.rendered) }"
  }

  provisioner "local-exec" {

    command = "kubectl apply -f .kube/dashboard-portal.yml"

  }

  provisioner "local-exec" {
    when = "destroy"

    command = "kubectl delete -f .kube/dashboard-portal.yml"

    on_failure = "continue"
  }

  depends_on = ["local_file.dashboard-portal"]}
