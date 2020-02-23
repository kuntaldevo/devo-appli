

data "aws_ami" "paxata-server" {

  most_recent = true

  filter {
    name   = "tag:role"
    values = ["paxata-server"]
  }

  filter {
    name   = "tag:distro-id"
    values = list ( lookup( var.tag-map, "distro-id" ) )
  }

  owners = [ "self" ]
}

data "aws_ami" "pipeline-server" {

  most_recent = true

  filter {
    name   = "tag:role"
    values = ["pipeline-server"]
  }

  filter {
    name   = "tag:distro-id"
    values = [ lookup( var.tag-map, "distro-id" ) ]
  }

  owners = [ "self" ]
}

data "aws_ami" "spark-master" {

  most_recent = true

  filter {
    name   = "tag:role"
    values = ["spark-master"]
  }

  filter {
    name   = "tag:distro-id"
    values = [ lookup( var.tag-map, "distro-id" ) ]
  }

  owners = [ "self" ]
}

data "aws_ami" "spark-worker" {

  most_recent = true

  filter {
    name   = "tag:role"
    values = ["spark-worker"]
  }

  filter {
    name   = "tag:distro-id"
    values = [ lookup( var.tag-map, "distro-id" ) ]
  }

  owners = [ "self" ]
}

data "aws_ami" "proxy-server" {

  most_recent = true

  filter {
    name   = "tag:role"
    values = ["proxy-server"]
  }

  filter {
    name   = "tag:distro-id"
    values = [ lookup( var.tag-map, "distro-id" ) ]
  }

  owners = [ "self" ]
}


data "aws_ami" "mongo-server" {

  most_recent = true

  filter {
    name   = "tag:role"
    values = ["mongo-server"]
  }

  filter {
    name   = "tag:distro-id"
    values = [ lookup( var.tag-map, "distro-id" ) ]
  }

  owners = [ "self" ]
}
