resource "azurerm_network_security_group" "mongo-server-27017" {

  name                = "${var.env-key}.${var.mongo-server-name}.27017"
  location                     = "${var.region-id}"
  resource_group_name          = "${azurerm_resource_group.default.name}"

    security_rule {
        name                       = "MONGO"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "27017"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
    }

    tags {
      cluster-id = "${var.cluster-id}"
      tf-config = "${var.tf-config}"
      tf-resource = "azurerm_network_security_group.default"
    }
}
