

resource "aws_launch_configuration" "mongo" {

  associate_public_ip_address = false

  name_prefix                 = "${var.env-key}.mongo-server."

  iam_instance_profile        = local.instance-profile-name
  image_id                    = data.aws_ami.eks-worker.id
  instance_type               = var.mongo-instance-type
  key_name                    = var.aws-key-pair
  security_groups             = [ aws_security_group.node.id ]

  spot_price                  = local.mongo-spot-price

  user_data_base64            = base64encode( format( "%s\n%s", data.template_file.user-data-common.rendered, data.template_file.mongo-user-data.rendered) )

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [ aws_eks_cluster.eks ]
  # Tags N/A
}
