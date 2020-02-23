
resource "aws_iam_policy" "velero" {

  name        = "velero-policy"
  path        = "/"
  description = "Allow Velero to do its thing "

  policy = data.template_file.velero.rendered

}


data "template_file" "velero" {

  template = file("${path.module}/velero-policy.template")
  
  vars = {
    BUCKET = "*.velero.backup.devops.paxata.com"
  }
}
