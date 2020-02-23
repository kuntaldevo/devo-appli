
# Create a policy that will allow any instance to access the S3 Library

resource "aws_iam_policy" "library-s3" {

    count = var.create-policy

    name = "${local.env-key}.${local.region-id}.library-s3"

    description = "Allow a EC2 Instance access to the library in S3"

    policy = data.template_file.policy-library-s3[0].rendered
}
