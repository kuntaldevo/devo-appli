


resource "aws_launch_configuration" "spark-server" {

  associate_public_ip_address = false

  name_prefix                 = "${var.env-key}.spark-server."

  iam_instance_profile        = local.instance-profile-name
  image_id                    = data.aws_ami.eks-worker.id
  instance_type               = var.spark-server-instance-type
  key_name                    = var.aws-key-pair
  security_groups             = [ aws_security_group.node.id ]

  spot_price                  = local.spark-spot-price

  user_data_base64            = base64encode( format( "%s\n%s\n%s", data.template_file.user-data-common.rendered,file("${path.module}/spark-raid.bash"), data.template_file.user-data-spark-server.rendered) )

  ephemeral_block_device {
    device_name = "/dev/xvdf"
    virtual_name = "ephemeral0"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [ aws_eks_cluster.eks ]
  # Tags N/A
}
