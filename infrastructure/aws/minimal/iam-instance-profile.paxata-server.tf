
resource "aws_iam_instance_profile" "paxata-server" {

  name  = "${var.env-key}.${var.region-id}.library-s3"

  role = aws_iam_role.paxata-server.name

# Tags N/A
}


resource "aws_iam_role" "paxata-server" {

  name = "${var.env-key}.${var.region-id}.paxata-server"

  path = "/"

### Use this policy for now.  Until I have a way to disable creating a role at all
  assume_role_policy = module.library-policy.trust-doc

# Tags N/A

}


resource "aws_iam_role_policy_attachment" "paxata-server-s3" {

    role       = aws_iam_role.paxata-server.name
    policy_arn = module.library-policy.role-id

}
