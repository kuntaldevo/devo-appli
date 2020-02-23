

data "aws_iam_policy_document" "jumpcloud-dev-admin" {

  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithSAML"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${var.account-id}:saml-provider/JumpCloudAdmin"]
    }
    
    condition {
      test = "StringEquals"
      variable = "SAML:aud"
      values = ["https://signin.aws.amazon.com/saml"]
    }

  }
}
