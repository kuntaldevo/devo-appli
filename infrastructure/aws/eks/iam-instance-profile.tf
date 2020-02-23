
locals {

  create-instance-profile = "${ ( var.provided-iam-instance-profile-arn != "") ? 0 : 1 }"

  generated-instance-profile-name = element(concat(aws_iam_instance_profile.node.*.name, list("")), 0)

  instance-profile-name = "${ ( local.create-instance-profile == 0 ) ? var.provided-iam-instance-profile-arn : local.generated-instance-profile-name }"

}


resource "aws_iam_instance_profile" "node" {

  count = local.create-instance-profile

  name = "${var.env-key}.${local.region-id}"

  role = aws_iam_role.node[0].name
}

# To Manually Delete,  aws iam delete-instance-profile --instance-profile-name paxata-eks.us-west-2
