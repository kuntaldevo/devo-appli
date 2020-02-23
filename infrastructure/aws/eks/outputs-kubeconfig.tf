#
# Generate the KubeConfig for this cluster
#


# Put a copy of the KubeConfig in the local
resource "local_file" "kubeconfig" {

  count = var.do-eks

  content     = data.template_file.kubeconfig.0.rendered

  filename = ".kube/kubeconfig.yml"
}

# Add the KubeConfig to the default ~/.kube/config
resource "null_resource" "kubeconfig" {

  count = var.do-eks

  triggers = {
     always =  uuid()
  }

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.env-key} --region ${local.region-id}"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl config delete-cluster ${aws_eks_cluster.eks.arn}"
    on_failure = continue
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl config delete-context ${aws_eks_cluster.eks.arn}"
    on_failure = continue
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl config unset users.${aws_eks_cluster.eks.arn}"
    on_failure = continue
  }

  depends_on = [ aws_eks_cluster.eks ]

}
