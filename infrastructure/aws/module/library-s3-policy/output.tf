

locals {

### https://www.terraform.io/upgrade-guides/0-11.html#referencing-attributes-from-resources-with-count-0
  role-id = element(concat(aws_iam_policy.library-s3.*.arn, list("")), 0)

  trust-doc = element(concat(data.aws_iam_policy_document.assume-role-library-s3.*.json, list("")), 0)
}

output "role-id" {

  value = var.create-policy ? local.role-id : ""

}

output "trust-doc" {

  value = var.create-policy ? local.trust-doc : ""

}
