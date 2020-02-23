
output "tfstate-resource-group" {
  value = "${azurerm_resource_group.default.name}"
}

output "storage-account" {
  value = "${azurerm_storage_account.default.name}"
}
