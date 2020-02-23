
resource "aws_instance" "instana" {

  ami                         = data.aws_ami.region-monitor.id
  instance_type               = var.instana-region-server-instance-type
  ebs_optimized               = false
  key_name                    = var.aws-key-pair
  subnet_id                   = module.vpc.public-subnet-id
  vpc_security_group_ids      = [ aws_security_group.paxata.id ]

  user_data     = element(module.instana-user-data.user-data, count.index)

  iam_instance_profile = aws_iam_instance_profile.instana-region-server.name

  tags = merge(var.tag-map, map("Name", "${var.env-key} instana-region-monitor-server","tf-resource", "aws_instance.instana-region-server"))

}
