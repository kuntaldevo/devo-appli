

resource "aws_launch_configuration" "general" {

  count = "${length(var.node-types)}"

  associate_public_ip_address = true

  iam_instance_profile        = "${aws_iam_instance_profile.node.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "${lookup( var.node-types[count.index], "instance-type" ) }"
  key_name                    = var.aws-key-pair
  security_groups             = ["${aws_security_group.node.id}"]

  name_prefix                 = "${var.env-key}.${lookup( var.node-types[count.index], "role-id" ) }."

  user_data_base64            = "${base64encode(data.template_file.user-data-general.rendered)}"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_eks_cluster.eks"]
  # Tags N/A
}
