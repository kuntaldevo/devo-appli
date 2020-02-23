
#Get an AZ to use, where any that are'unavailable' or if any that are filtered out due to some sort of restriction like EC2 instance types
module "availability-zone" {

  source = "../module/availability-zone"

  region-id = var.region-id
  excluded-zones = ["${var.excluded-availability-zones}"]

}
