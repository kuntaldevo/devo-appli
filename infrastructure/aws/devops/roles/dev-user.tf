

resource "aws_iam_role" "dev-user" {

  name = "dev-user2"

  assume_role_policy = data.aws_iam_policy_document.jumpcloud-dev-user.json

   description = "This role is tied to the JumpCloud SAML application called AWS-Dev User which grants developer level access to the dev AWS environment"

   max_session_duration = "43200"

   tags = var.tag-map

}

locals {

 dev-user-polices = [ "ecr-read-write","eks-dev","terraform-create-update2","route53-list-update-all", "elb-describe"]

}


resource "aws_iam_role_policy_attachment" "dev-user" {

  count = length( local.dev-user-polices )

  policy_arn = "arn:aws:iam::${var.account-id}:policy/${ element( local.dev-user-polices, count.index) }"

  role       = aws_iam_role.dev-user.name
}
