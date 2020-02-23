
resource "aws_iam_instance_profile" "pipeline-server" {

  count = "${var.feature-ddl && var.feature-library == "s3" ? 1 : 0}"

  name  = "${var.env-key}.${var.region-id}.pipeline-server"

  role = "${aws_iam_role.pipeline-server.name}"

# Tags N/A
}

resource "aws_iam_role" "pipeline-server" {

  count = "${var.feature-ddl && var.feature-library == "s3" ? 1 : 0}"

  name = "${var.env-key}.${var.region-id}.pipeline-server"

  path = "/"

### Use this policy for now.  Until I have a way to disable creating a role at all
  assume_role_policy = "${module.library-policy.trust-doc}"

# Tags N/A

}


resource "aws_iam_role_policy_attachment" "pipeline-server-s3" {

  count = "${var.feature-ddl && var.feature-library == "s3" ? 1 : 0}"

  role       = "${aws_iam_role.pipeline-server.name}"
  policy_arn = module.library-policy.role-id

}
