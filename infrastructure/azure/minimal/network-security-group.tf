resource "azurerm_network_security_group" "default" {

  name                = "${var.env-key}.default"
  location                     = "${var.region-id}"
  resource_group_name          = "${azurerm_resource_group.default.name}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags {
      cluster-id = "${var.cluster-id}"
      tf-config = "${var.tf-config}"
      tf-resource = "azurerm_network_security_group.default"
    }
}

resource "azurerm_network_security_group" "ingress-internet-80" {

  name                = "${var.env-key}.ingress-internet-80"
  location                     = "${var.region-id}"
  resource_group_name          = "${azurerm_resource_group.default.name}"

    security_rule {
        name                       = "HTTP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "80"
        destination_port_range     = "80"
        source_address_prefix      = "104.189.208.101"
        destination_address_prefix = "${azurerm_network_interface.paxata-server.private_ip_address}"
    }

    tags {
      cluster-id = "${var.cluster-id}"
      tf-config = "${var.tf-config}"
      tf-resource = "azurerm_network_security_group.default"
    }
}

resource "azurerm_network_security_group" "ingress-internet-443" {

  name                = "${var.env-key}.ingress-internet-443"
  location                     = "${var.region-id}"
  resource_group_name          = "${azurerm_resource_group.default.name}"

    security_rule {
        name                       = "HTTP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "443"
        destination_port_range     = "443"
        source_address_prefix      = "104.189.208.101"
        destination_address_prefix = "${azurerm_network_interface.paxata-server.private_ip_address}"
    }

    tags {
      cluster-id = "${var.cluster-id}"
      tf-config = "${var.tf-config}"
      tf-resource = "azurerm_network_security_group.default"
    }
}
