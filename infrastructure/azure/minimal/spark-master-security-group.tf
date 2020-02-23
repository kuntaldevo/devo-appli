resource "azurerm_network_security_group" "spark-master-8080" {

  name                = "${var.env-key}.${var.spark-master-name}.8080"
  location                     = "${var.region-id}"
  resource_group_name          = "${azurerm_resource_group.default.name}"

    security_rule {
        name                       = "spark-master-8080"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
    }

    tags {
      cluster-id = "${var.cluster-id}"
      tf-config = "${var.tf-config}"
      tf-resource = "azurerm_network_security_group.spark-master-8080"
    }
}

resource "azurerm_network_security_group" "spark-master-4040" {

  name                = "${var.env-key}.${var.spark-master-name}.4040"
  location                     = "${var.region-id}"
  resource_group_name          = "${azurerm_resource_group.default.name}"

    security_rule {
        name                       = "spark-master-4040"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "4040"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
    }

    tags {
      cluster-id = "${var.cluster-id}"
      tf-config = "${var.tf-config}"
      tf-resource = "azurerm_network_security_group.spark-master-4040"
    }
}
