

resource "aws_iam_user" "jenkins-ci" {

  name = "jenkins-ci"

  tags = var.tag-map
}


locals {

 jenkins-ci-policies = [ "ecr-read-write"]

}


resource "aws_iam_user_policy_attachment" "jenkins-ci" {

  count = length( local.jenkins-ci-policies )

  policy_arn = "arn:aws:iam::${var.account-id}:policy/${ element( local.jenkins-ci-policies, count.index) }"

  user       = aws_iam_user.jenkins-ci.name
}


resource "aws_iam_access_key" "jenkins-ci" {

  user    = aws_iam_user.jenkins-ci.name

}

#NOTE, This doesn't actually output anything to the screen.  GO to the S3 tfstate for devops-aws and get the key there
output "secret" {
  value = aws_iam_access_key.jenkins-ci.secret
}
