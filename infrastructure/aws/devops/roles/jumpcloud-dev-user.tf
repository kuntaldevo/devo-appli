

data "aws_iam_policy_document" "jumpcloud-dev-user" {

  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithSAML"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${var.account-id}:saml-provider/JumpCloud"]
    }

    condition {
      test = "StringEquals"
      variable = "SAML:aud"
      values = ["https://signin.aws.amazon.com/saml"]
    }
    
  }
}
