

resource "aws_iam_role" "dev-admin" {

  name = "dev-admin2"

  assume_role_policy = data.aws_iam_policy_document.jumpcloud-dev-admin.json

   description = "This role is tied to the JumpCloud SAML application called AWS-Dev admin which grants developer level access to the dev AWS environment"

   max_session_duration = "43200"

   tags = var.tag-map

}

locals {

dev-admin-policies = []
 dev-admin-policies-aws-managed = [ "AdministratorAccess"]

}


resource "aws_iam_role_policy_attachment" "dev-admin" {

  count = length( local.dev-admin-policies )

  policy_arn = "arn:aws:iam::${var.account-id}:policy/${ element( local.dev-admin-policies, count.index) }"

  role       = aws_iam_role.dev-admin.name
}

resource "aws_iam_role_policy_attachment" "dev-admin-aws-managed" {

  count = length( local.dev-admin-policies-aws-managed )

  policy_arn = "arn:aws:iam::aws:policy/${ element( local.dev-admin-policies-aws-managed, count.index) }"

  role       = aws_iam_role.dev-admin.name
}
