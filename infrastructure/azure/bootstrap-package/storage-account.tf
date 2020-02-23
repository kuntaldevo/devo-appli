
resource "azurerm_storage_account" "default" {

  name                     = "vmi0${random_id.randomId.hex}"
  resource_group_name      = "${azurerm_resource_group.default.name}"
  location                 = "${var.region-id}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags {
    cluster-id = "${var.cluster-id}"
    tf-config = "${var.tf-config}"
    distro-id = "{var.distro-id}"
  }
}

resource "azurerm_storage_container" "terraform-state" {
  name                  = "terraform-state"
  resource_group_name   = "${azurerm_resource_group.default.name}"
  storage_account_name  = "${azurerm_storage_account.default.name}"
  container_access_type = "private"

# Tags N/A
}

resource "azurerm_storage_blob" "default" {

  name = "terraform-state"

  resource_group_name    = "${azurerm_resource_group.default.name}"
  storage_account_name   = "${azurerm_storage_account.default.name}"
  storage_container_name = "${azurerm_storage_container.terraform-state.name}"

  type = "page"
  size = 5120

# Tags N/A
}
