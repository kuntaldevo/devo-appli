
resource azurerm_virtual_network "default"
{
  name                = var.env-key
  resource_group_name = "${azurerm_resource_group.default.name}"
  address_space       = ["${var.full-subnet-cidr}"]
  location            = "${var.region-id}"


  tags {
    cluster-id = "${var.cluster-id}"
    tf-config = "${var.tf-config}"
    tf-resource = "azurerm_virtual_network.default"
  }
}
