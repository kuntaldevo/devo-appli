

resource "aws_instance" "ebs" {


  ami           = "ami-248eb141"
  subnet_id     = module.vpc.subnet-id
  vpc_security_group_ids      = [ aws_security_group.allow-ssh.id ]

  instance_type = "i3.xlarge"

  # The Region's Key name to use to allow SSH
  key_name   = var.aws-key-pair

  tags = merge(var.tag-map, map("Name", "${var.env-key} ebs","tf-resource", "aws_instance.ebs"))

  ebs_block_device
  {
     device_name = "/dev/xvdf"
     volume_type = "io1"
     volume_size = "8"
     iops = "400"
  }

  ebs_block_device
  {
     device_name = "/dev/xvdg"
     volume_type = "io1"
     volume_size = "8"
     iops = "400"
  }

  ebs_block_device
  {
     device_name = "/dev/xvdh"
     volume_type = "io1"
     volume_size = "8"
     iops = "400"
  }

  ebs_block_device
  {
     device_name = "/dev/xvdi"
     volume_type = "io1"
     volume_size = "8"
     iops = "400"
  }

  ebs_block_device
  {
     device_name = "/dev/xvdj"
     volume_type = "io1"
     volume_size = "8"
     iops = "400"
  }

}
