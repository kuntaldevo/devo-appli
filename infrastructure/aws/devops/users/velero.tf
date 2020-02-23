

resource "aws_iam_user" "velero" {

  name = "velero"

  tags = var.tag-map
}


locals {

 velero-policies = [ "velero-policy"]

}


resource "aws_iam_user_policy_attachment" "velero" {

  count = length( local.velero-policies )

  policy_arn = "arn:aws:iam::${var.account-id}:policy/${ element( local.velero-policies, count.index) }"

  user       = aws_iam_user.velero.name
}
