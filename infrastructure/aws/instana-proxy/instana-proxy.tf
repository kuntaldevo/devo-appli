
resource "aws_instance" "instana-proxy" {

  ami                         = data.aws_ami.instana-proxy.id
  instance_type               = var.instana-proxy-instance-type
  ebs_optimized               = false
  key_name                    = var.aws-key-pair
  subnet_id                   = module.vpc.public-subnet-id
  vpc_security_group_ids      = [ aws_security_group.instana-proxy.id ]

  user_data     = element(module.instana-user-data.user-data, count.index)

#  iam_instance_profile = aws_iam_instance_profile.instana-proxy.name

  tags = merge(var.tag-map, map("Name", "${var.env-key} instana-proxy","tf-resource", "aws_instance.instana-proxy"))

}
