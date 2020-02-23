


resource "aws_instance" "single-server" {

  ami                         = var.server-ami
  instance_type               = var.server-instance-type
  ebs_optimized               = false
  key_name                    = var.aws-key-pair
  subnet_id                   = module.vpc.subnet-id
  vpc_security_group_ids      = [ aws_security_group.single-server.id ]
  user_data     = module.vpc.subnet-id

#  iam_instance_profile = aws_iam_instance_profile.instana-region-server.name


  tags = merge(var.tag-map, map("Name", "${var.env-key} single-server","tf-resource", "aws_instance.single-server"))

}
