resource "azurerm_public_ip" "default" {

    name                = var.env-key

    location                     = "${var.region-id}"

    resource_group_name          = "${azurerm_resource_group.default.name}"

    public_ip_address_allocation = "dynamic"

    tags {
      cluster-id = "${var.cluster-id}"
      tf-config = "${var.tf-config}"
      tf-resource = "azurerm_public_ip.default"
    }
}
