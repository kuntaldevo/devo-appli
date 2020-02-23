
resource "azurerm_storage_account" "logs" {
    name                = "logs${random_id.randomId.hex}"
    resource_group_name = "${azurerm_resource_group.default.name}"
    location = "${var.region-id}"
    account_replication_type = "LRS"
    account_tier = "Standard"


    tags {
      cluster-id = "${var.cluster-id}"
      tf-config = "${var.tf-config}"
      tf-resource = "azurerm_resource_group.default"
    }
}
