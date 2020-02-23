

resource "aws_launch_configuration" "general" {

  associate_public_ip_address = false

  iam_instance_profile        = local.instance-profile-name
  image_id                    = data.aws_ami.eks-worker.id
  instance_type               = var.general-instance-type
  key_name                    = var.aws-key-pair
  security_groups             = [ aws_security_group.node.id ]

  name_prefix                 = "${var.env-key}.general."
  spot_price                  = local.general-spot-price

  user_data_base64            = base64encode( format( "%s\n%s", data.template_file.user-data-common.rendered, data.template_file.user-data-general.rendered) )

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [ aws_eks_cluster.eks ]
  # Tags N/A
}
