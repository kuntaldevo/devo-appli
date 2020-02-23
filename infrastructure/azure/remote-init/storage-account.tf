
resource "azurerm_storage_account" "default" {

#Name needs to be universally unique
  name                     = "tfstate0${var.customer-id}0${var.cluster-id}0"
  resource_group_name      = "${azurerm_resource_group.default.name}"
  location                 = "${var.region-id}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

 tags {
    customer-id = "${var.customer-id}"
    cluster-id = "${var.cluster-id}"
    tf-config = "${var.tf-config}"
    env-key = var.env-key

    scm-branch  = "${var.scm-branch}"
    scm-sha    = "${var.scm-sha}"
    scm-user  = "${var.scm-user}"
    scm-email    = "${var.scm-email}"

    create-user    = "${var.create-user}"
    create-timestamp    = "${var.create-timestamp}"

    approver = "${var.approver}"
    expiration = "${var.expiration}"
    tf-resource = "azurerm_storage_account.default"
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
