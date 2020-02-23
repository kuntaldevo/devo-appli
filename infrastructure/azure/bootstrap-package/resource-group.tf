# Create a resource group
resource "azurerm_resource_group" "default" {
  name     = "vmi-${var.distro-id}"
  location = "${var.region-id}"

  tags {
    cluster-id = "${var.cluster-id}"
    tf-config = "${var.tf-config}"
  }
}
