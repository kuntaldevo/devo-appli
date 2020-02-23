
# Display the IP address of the Paxata UI server
output "ui-public-ip" {
  value = "${azurerm_public_ip.default.ip_address}"
}

#Display the name of the resource group that contains all of the objects in the cluster
output "cluster-resource-group" {
  value = "${azurerm_resource_group.default.name}"
}

# Display the IP address of the Paxata UI server
output "ui-public-url" {
  value = "${module.paxatadev.ui-url}"
}
