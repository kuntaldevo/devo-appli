resource "azurerm_network_interface" "paxata-server" {

  name                = "${var.env-key}.${var.paxata-server-name}"
  location            = "${var.region-id}"
  resource_group_name = "${azurerm_resource_group.default.name}"

  ip_configuration {
      name                          = "${var.env-key}.${var.paxata-server-name}"
      subnet_id                     = "${azurerm_subnet.public.id}"
      private_ip_address_allocation = "dynamic"
      public_ip_address_id          = "${azurerm_public_ip.default.id}"
  }

  tags {
    cluster-id = "${var.cluster-id}"
    tf-config = "${var.tf-config}"
    tf-resource = "azurerm_network_interface.paxata-server"
  }
}
