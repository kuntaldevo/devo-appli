
resource "aws_iam_instance_profile" "instana-region-server" {

  name  = "instana.${var.region-id}"

  role = "${aws_iam_role.role.name}"

# Tags N/A
}
