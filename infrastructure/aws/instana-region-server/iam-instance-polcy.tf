


resource "aws_iam_role" "role" {

  name = "instana.${var.region-id}"

  path = "/"

  assume_role_policy = "${data.aws_iam_policy_document.assume-role-policy.json}"

# Tags N/A

}



resource "aws_iam_role_policy" "instana-region-server" {

  name = "instana-region-server"

  role = "${aws_iam_role.role.id}"

  policy = "${data.aws_iam_policy_document.policy.json}"

  # Tags N/A

}
