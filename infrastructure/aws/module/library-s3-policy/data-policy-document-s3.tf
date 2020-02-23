
data "template_file" "policy-library-s3" {

  count = var.create-policy

  template  = "${file("${path.module}/json/library-s3-policy.json")}"

  vars = {
    library-name = var.library-name
  }
}

data "aws_iam_policy_document" "assume-role-library-s3" {

  count = var.create-policy

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
