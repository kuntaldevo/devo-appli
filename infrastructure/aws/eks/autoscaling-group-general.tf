

locals {
  general-tags = [
    {
    key                 = "Name"
    value               = "${var.env-key}.general"
    propagate_at_launch = true
    },
    {
    key                 = "role-id"
    value               = "general-server"
    propagate_at_launch = true
    },
    {
    key                 = "kubernetes.io/role"
    value               = "general-server"
    propagate_at_launch = true
    }
  ]
}

resource "aws_autoscaling_group" "general" {

  name                 = "${var.env-key}.general.asg-grp"

  launch_configuration = aws_launch_configuration.general.id
  vpc_zone_identifier  = data.aws_subnet_ids.node-subnets.ids

  desired_capacity     = var.general-desired-capacity
  min_size             = var.general-min-size
  max_size             = var.general-max-size

  tags = concat( data.null_data_source.autoscaling-tags.*.outputs, local.asg-cluster-tags, local.general-tags )
}
