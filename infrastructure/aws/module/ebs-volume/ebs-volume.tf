
locals {

  env-key = lookup(var.tag-map, "env-key")

  total-volumes = var.instance-count * var.volume-count

}


resource "aws_ebs_volume" "volume" {

    count = local.total-volumes

    availability_zone = var.zone[count.index / var.volume-count]

    type = var.type

    size = var.size

#    iops = var.iops

    tags = merge(var.tag-map, map( "tf-resource", "aws_ebs_volume.volume", "Name", "${local.env-key} volume-${count.index}"))

}

resource "aws_volume_attachment" "attachment" {

  count = local.total-volumes

  device_name = "/dev/${var.volume-label[count.index % var.volume-count]}"

  volume_id   = aws_ebs_volume.volume.*.id[count.index]

  instance_id = var.instance-id[count.index / var.volume-count ]

  force_detach = true

}
