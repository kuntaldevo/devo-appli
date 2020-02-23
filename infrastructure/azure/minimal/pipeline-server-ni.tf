resource "azurerm_network_interface" "pipeline-server" {

  name                = "${var.env-key}.${var.pipeline-server-name}"
  location            = "${var.region-id}"
  resource_group_name = "${azurerm_resource_group.default.name}"

  ip_configuration {
      name                          = "${var.env-key}.${var.pipeline-server-name}"
      subnet_id                     = "${azurerm_subnet.private.id}"
      private_ip_address_allocation = "dynamic"
  }

  tags {
    cluster-id = "${var.cluster-id}"
    tf-config = "${var.tf-config}"
    tf-resource = "azurerm_network_interface.pipeline-server"
  }
}
