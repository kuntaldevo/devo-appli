

data "template_file" "kubeconfig" {

  count = var.do-eks

  template = file("kubeconfig.template")

  vars = {
    env-key = var.env-key
    endpoint = aws_eks_cluster.eks.endpoint
    certificate-authority = aws_eks_cluster.eks.certificate_authority.0.data
  }

}
