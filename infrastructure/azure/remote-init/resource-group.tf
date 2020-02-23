# Create a resource group
resource "azurerm_resource_group" "default" {
  name     = "tfstate.${var.env-key}"
  location = "${var.region-id}"

  tags {
     customer-id = "${var.customer-id}"
     cluster-id = "${var.cluster-id}"
     tf-config = "${var.tf-config}"
     env-key = var.env-key

     scm-branch  = "${var.scm-branch}"
     scm-sha    = "${var.scm-sha}"
     scm-user  = "${var.scm-user}"
     scm-email    = "${var.scm-email}"

     create-user    = "${var.create-user}"
     create-timestamp    = "${var.create-timestamp}"

     approver = "${var.approver}"
     expiration = "${var.expiration}"
     tf-resource = "azurerm_resource_group.default"
   }
}
