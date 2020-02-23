



resource "null_resource" "apply-pipeline-portal" {

  triggers = {
     on-change = "${ md5(data.template_file.pipeline-portal.rendered) }"
  }

  provisioner "local-exec" {

    command = "kubectl apply -f .kube/pipeline-portal.yml"

  }

  provisioner "local-exec" {
    when = "destroy"

    command = "kubectl delete -f .kube/pipeline-portal.yml"

    on_failure = "continue"
  }

  depends_on = ["local_file.pipeline-portal"]

}
