

data "aws_ami" "region-monitor" {

  most_recent = true

  filter {
    name   = "tag:role"
    values = ["instana-agent-server"]
  }

  filter {
    name   = "tag:distro-id"
    values = ["instana"]
  }

  owners = ["${module.aws.paxata-owner-id}"] # Paxata
}
