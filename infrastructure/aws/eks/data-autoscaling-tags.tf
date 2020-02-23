
# Convert the Tag Map into tags for the Autoscaling group


data "null_data_source" "autoscaling-tags" {

  count = length(var.tag-map)

  inputs = {
    key = element(keys(var.tag-map), count.index)
    value = element(values(var.tag-map), count.index)
    propagate_at_launch = "true"
  }
}
