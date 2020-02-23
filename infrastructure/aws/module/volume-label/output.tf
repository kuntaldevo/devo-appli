


locals {

  output = (var.create ) ? slice(var.labels-ebs,0, var.volume-total ) : []

}




output "volume-labels" {

  value = local.output
}
