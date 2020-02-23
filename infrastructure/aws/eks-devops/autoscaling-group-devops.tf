

locals {
  devops-tags = [
    {
    key                 = "Name"
    value               = "${var.env-key}.devops"
    propagate_at_launch = true
    },
    {
    key                 = "role-id"
    value               = "devops-server"
    propagate_at_launch = true
    }
  ]
}

resource "aws_autoscaling_group" "devops" {

  count = "${length(var.node-types)}"

  name                 = "${var.env-key}.devops.asg-grp"

  desired_capacity     = "${var.autoscale-capacity}"
  launch_configuration = "${aws_launch_configuration.devops.*.id[count.index]}"
  min_size             = "${var.autoscale-min}"
  max_size             = "${var.autoscale-max}"
  vpc_zone_identifier  = ["${data.aws_subnet_ids.found.ids}"]

  tags = ["${concat(
    data.null_data_source.autoscaling-tags.*.outputs,
    local.asg-cluster-tags, local.devops-tags,
    list( data.null_data_source.node-types.*.outputs[count.index] ),
    )}"]
}
