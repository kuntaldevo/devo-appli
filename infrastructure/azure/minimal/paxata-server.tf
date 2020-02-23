
variable "paxata-server-name" {
  type = "string"
  default = "paxata-server"
}


resource "azurerm_virtual_machine" "paxata-server" {

  name                = "${var.env-key}.${var.paxata-server-name}"
  location            = var.region-id
  resource_group_name = "${azurerm_resource_group.default.name}"
  depends_on = ["azurerm_virtual_machine.mongo-server"]

  network_interface_ids = ["${azurerm_network_interface.paxata-server.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    id = "/subscriptions/${var.subscription-id}/resourceGroups/${var.vmi-resource-group}/providers/Microsoft.Compute/images/${var.paxata-server-name}"
  }

  storage_os_disk {
    name              = "${var.paxata-server-name}.os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

# OS_PROFILE's computer_name will set the host name of the VM
# The rest of the OS_PROFILE appears to be required, so I've set it to something, but it's not used for anything
  os_profile {
    computer_name  = "${var.paxata-server-name}"
    admin_username = "azureuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA8lLqHGYTtaFoP7VvOcc7qWUGJ4xYLZckfsaEyEvItx9CpkOv8A6/DLkbRP8+nETX1sxjvQ/CWMt0IA11gPkwuJh4XXijxXUQas8Z/h4C5EhzsTNNfrz4ec9neqA81j2m71ViSXm41Utu4239lB+DaQ3DOo6tDrTfhS6Ys/Tq3aWUm3EAPQhUcCy0U216Kzt+ikQerWV8eSDIt3qcdG4U39VotW5Xk3HgPEMvYJJcLWW0r4yxhT26wBF6r3itlZ4lq8rZfB+/QdaqnKVTio926HTxxWwJc10qSl1pFTTK6VOlHjP9F/a5wuUPiNPiQh9IYI+rr8k7mzyKvL8rp5I+3w== fake-key"
        }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.logs.primary_blob_endpoint}"
  }

  tags {
      cluster-id   = "${var.cluster-id}"
      tf-config = "${var.tf-config}"
      tf-resource = "azurerm_virtual_machine.paxata-server"
   }
}
