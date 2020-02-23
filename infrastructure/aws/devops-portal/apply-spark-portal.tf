



resource "null_resource" "apply-spark-portal" {

  triggers = {
     on-change = "${ md5(data.template_file.spark-portal.rendered) }"
  }

  provisioner "local-exec" {

    command = "kubectl apply -f .kube/spark-portal.yml"

  }

  provisioner "local-exec" {
    when = "destroy"

    command = "kubectl delete -f .kube/spark-portal.yml"

    on_failure = "continue"
  }

  depends_on = ["local_file.spark-portal"]

}
