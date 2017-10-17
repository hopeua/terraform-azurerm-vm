output "resource_group_name" {
  value = "${azurerm_resource_group.default.name}"
}
output "network_security_group_name" {
  value = "${azurerm_network_security_group.default.name}"
}
