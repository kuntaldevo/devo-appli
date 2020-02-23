


locals {

  create-worker-node-role = "${ ( var.provided-worker-node-role-arn != "") ? 0 : 1 }"

  generated-worker-node-role = element(concat(aws_iam_role.node.*.arn, list("")), 0)

  worker-node-role-arn = "${ ( local.create-worker-node-role == 0 ) ? var.provided-worker-node-role-arn : local.generated-worker-node-role }"

}


resource "aws_iam_role" "node" {

  count = local.create-worker-node-role

  name = "${var.env-key}.${local.region-id}.node-assume"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
