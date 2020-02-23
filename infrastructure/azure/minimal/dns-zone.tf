
resource "azurerm_dns_zone" "default" {

  name                = var.private-domain
  
  resource_group_name = "${azurerm_resource_group.default.name}"
}

resource "azurerm_dns_a_record" "paxata-server" {
  name                = "paxata-server"
  zone_name           = "${azurerm_dns_zone.default.name}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  ttl                 = 300
  records             = ["${azurerm_network_interface.paxata-server.private_ip_address}"]
}

resource "azurerm_dns_a_record" "mongo-server" {
  name                = "mongo-server"
  zone_name           = "${azurerm_dns_zone.default.name}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  ttl                 = 300
  records             = ["${azurerm_network_interface.mongo-server.private_ip_address}"]
}
