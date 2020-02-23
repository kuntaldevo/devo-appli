
resource "aws_iam_instance_profile" "spark-worker" {

  count = "${var.feature-ddl && var.feature-library == "s3" ? 1 : 0}"

  name  = "${var.env-key}.${var.region-id}.spark-worker"

  role = "${aws_iam_role.spark-worker.name}"

# Tags N/A
}

resource "aws_iam_role" "spark-worker" {

  name = "${var.env-key}.${var.region-id}.spark-worker"

  path = "/"

### Use this policy for now.  Until I have a way to disable creating a role at all
  assume_role_policy = "${module.library-policy.trust-doc}"

# Tags N/A

}


resource "aws_iam_role_policy_attachment" "spark-worker-s3" {

    role       = "${aws_iam_role.spark-worker.name}"
    policy_arn = module.library-policy.role-id

}
