
resource "azurerm_subnet" "public" {

  name                = "${var.env-key}-public"

  virtual_network_name = azurerm_virtual_network.default.name

  resource_group_name  = azurerm_resource_group.default.name

  address_prefix       = var.public-subnet-cidr

  # Tags N/A

}
