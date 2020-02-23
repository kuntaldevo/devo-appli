

variable "node-policies" {

   default = []

   description = "Additional Node Policies that might be needed. This is defined per-STAGE"

}

locals {
  asg-cluster-tags = [

    {
    key                 = "k8s.io/cluster-autoscaler/${var.env-key}"
    value               = "owned"
    propagate_at_launch = true
    },
    {
    key                 = "kubernetes.io/cluster/${var.env-key}"
    value               = "owned"
    propagate_at_launch = true
    },
    {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "true"
    propagate_at_launch = true
    },
    {
    key                 = "tf-resource"
    value               = "aws_autoscaling_group.eks"
    propagate_at_launch = true
    }
  ]
}

variable "ssh-ingress-map" {
  type = list(map(string))
}
