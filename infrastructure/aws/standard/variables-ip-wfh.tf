

locals {

  wfh = "${length (var.wfh-ip) == "0" ? 0 : 1 }"
  wfh-cidr = "${var.wfh-ip}/32"
  wfh-map = ["${map ( "cidr", local.wfh-cidr, "description", "WFH"  )}"]

}

### The IP address of your home or remote location
# If the "--wfh" flag is set then this will be added to the
# Paxata Server's security to allow easy access for you to SSH to this cluster
# Until I get some more logic around this, if it's not set then just default it to the localHost IP
variable "ip-wfh" {

  type = string

  default = ""
}
