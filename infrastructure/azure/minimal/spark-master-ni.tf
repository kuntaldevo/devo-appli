resource "azurerm_network_interface" "spark-master" {

  name                = "${var.env-key}.${var.spark-master-name}"
  location            = "${var.region-id}"
  resource_group_name = "${azurerm_resource_group.default.name}"

  ip_configuration {
      name                          = "${var.env-key}.${var.spark-master-name}"
      subnet_id                     = "${azurerm_subnet.private.id}"
      private_ip_address_allocation = "dynamic"
  }

  tags {
    cluster-id = "${var.cluster-id}"
    tf-config = "${var.tf-config}"
    tf-resource = "azurerm_network_interface.${var.spark-master-name}"
  }
}
