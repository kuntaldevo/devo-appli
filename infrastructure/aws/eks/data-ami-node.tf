#
# EKS Worker Nodes Resources
#  * Data source to fetch latest EKS worker AMI
#  * AutoScaling Launch Configuration to configure worker instances
#  * AutoScaling Group to launch worker instances
#


data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-1.14-*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}
