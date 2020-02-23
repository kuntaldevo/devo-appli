

locals {
  mongo-tags = [
    {
    key                 = "Name"
    value               = "${var.env-key}.mongo"
    propagate_at_launch = true
    },
    {
    key                 = "role-id"
    value               = "mongo-server"
    propagate_at_launch = true
    },
    {
    key                 = "kubernetes.io/role"
    value               = "mongo-server"
    propagate_at_launch = true
    }
  ]
}

resource "aws_autoscaling_group" "mongo" {

  name                 = "${var.env-key}.mongo.asg-grp"

  launch_configuration = aws_launch_configuration.mongo.id
  vpc_zone_identifier  = data.aws_subnet_ids.mongo.ids

  desired_capacity     = var.mongo-node-total
  min_size             = var.mongo-node-total
  max_size             = var.mongo-node-total

  tags = concat( data.null_data_source.autoscaling-tags.*.outputs, local.asg-cluster-tags, local.mongo-tags )
}
