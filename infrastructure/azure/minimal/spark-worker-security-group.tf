resource "azurerm_network_security_group" "spark-worker-inbound" {

  name                = "${var.env-key}.${var.spark-worker-name}.inbound"
  location                     = "${var.region-id}"
  resource_group_name          = "${azurerm_resource_group.default.name}"

    security_rule {
        name                       = "spark-worker-inbound"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
    }

    tags {
      cluster-id = "${var.cluster-id}"
      tf-config = "${var.tf-config}"
      tf-resource = "azurerm_network_security_group.spark-worker-8090"
    }
}

resource "azurerm_network_security_group" "spark-worker-outbound" {

  name                = "${var.env-key}.${var.spark-worker-name}.outbound"
  location                     = "${var.region-id}"
  resource_group_name          = "${azurerm_resource_group.default.name}"

    security_rule {
        name                       = "spark-worker-outbound"
        priority                   = 1001
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
    }

    tags {
      cluster-id = "${var.cluster-id}"
      tf-config = "${var.tf-config}"
      tf-resource = "azurerm_network_security_group.spark-worker-4040"
    }
}
