

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
# More information: https://aws.amazon.com/blogs/opensource/improvements-eks-worker-node-provisioning/

# This is for the AMI to amazon-eks-node-vXX

data "template_file" "user-data-spark-server" {

  template = "${file("user-data-spark-server.template")}"

  vars = {
    cluster-name = "${local.cluster-name}"
  }
}
