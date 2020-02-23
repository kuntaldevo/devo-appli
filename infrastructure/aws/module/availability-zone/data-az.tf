

# Find available availability zones
data "aws_availability_zones" "available"
{
  state = "available"

}

# Go through the process of removing the 'excluded zones' from the data list of available zones
locals {
  all-items = "${data.aws_availability_zones.available.names}"
  item-to-remove = "${var.excluded-zones}"
  # Concat the two lists together, putting the list of elements we DO NOT want at the beginning of the list
  # Then distinct preserves the things we don't want and removes those same items from the back portion of the list
  list-with-item-in-front = "${distinct(concat(local.item-to-remove, local.all-items))}"
  # Now remove the front portion of elements we don't want, leaving the all-items with the filtered elements removed.
  list-without-items = "${slice(local.list-with-item-in-front, length(local.item-to-remove), length(local.list-with-item-in-front))}"
}

output "excluded-availability-zones"
{

  value = var.excluded-zones

}


output "filtered-availability-zones"
{

  value = local.list-without-items

}


output "selected"
{

  value = local.list-without-items[0]

}
