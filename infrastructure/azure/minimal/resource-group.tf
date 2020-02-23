# Create a resource group
resource "azurerm_resource_group" "default" {

  name     = var.env-key
  location = "${var.region-id}"

  tags {
    cluster-id = "${var.cluster-id}"
    tf-config = "${var.tf-config}"
    tf-resource = "azurerm_resource_group.default"
  }
}
