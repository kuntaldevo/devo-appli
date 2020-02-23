

resource "aws_iam_user" "team-city" {

  name = "team-city"

  tags = var.tag-map
}


locals {

 team-city-policies = [ "assume-eks-cluster-admin"]

}


resource "aws_iam_user_policy_attachment" "team-city" {

  count = length( local.team-city-policies )

  policy_arn = "arn:aws:iam::${var.account-id}:policy/${ element( local.team-city-policies, count.index) }"

  user       = aws_iam_user.team-city.name
}
