

locals {
  spark-tags = [
    {
    key                 = "Name"
    value               = "${var.env-key}.spark-server"
    propagate_at_launch = true
    },
    {
    key                 = "role-id"
    value               = "spark-server"
    propagate_at_launch = true
    },
    {
    key                 = "kubernetes.io/role"
    value               = "spark-server"
    propagate_at_launch = true
    }
  ]
}


resource "aws_autoscaling_group" "spark-server" {

# Prefix is for Roll Policy Filter
  name                 = "${var.env-key}.spark-server.asg-grp"

  launch_configuration = aws_launch_configuration.spark-server.id
  vpc_zone_identifier  = data.aws_subnet_ids.node-subnets.ids

  desired_capacity     = var.spark-server-desired-capacity
  min_size             = var.spark-server-min-size
  max_size             = var.spark-server-max-size

  tags = concat( data.null_data_source.autoscaling-tags.*.outputs, local.asg-cluster-tags, local.spark-tags )
}
