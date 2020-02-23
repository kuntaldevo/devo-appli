

data "aws_iam_policy_document" "allow-role-to-be-assumed" {

  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account-id}:root"]
    }
  }
}
