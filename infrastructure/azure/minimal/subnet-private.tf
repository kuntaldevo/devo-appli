
resource "azurerm_subnet" "private" {

  name                = "${var.env-key}-private"

  virtual_network_name = "${azurerm_virtual_network.default.name}"

  resource_group_name  = "${azurerm_resource_group.default.name}"

  address_prefix       = "${var.private-subnet-cidr}"

# Tags N/A

}
