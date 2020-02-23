

data "aws_ami" "instana-proxy" {

  most_recent = true

  filter {
    name   = "tag:role"
    values = ["instana-proxy"]
  }

  filter {
    name   = "tag:distro-id"
    values = ["instana-proxy"]
  }

  owners = ["${module.aws.paxata-owner-id}"] # Paxata
}
