output "network_security_group_id" {
  value       = { for k in azurerm_network_security_group.nsg : k => k.id }
  description = "Resource IDs of the Network Security Groups"
}

output "route_table_id" {
  value       = { for k in azurerm_route_table.route_table : k => k.id }
  description = "Resource IDs of the Route Tables"
}

output "virtual_network_id" {
  value       = azurerm_virtual_network.network.id
  description = "Resource ID of the Virtual Network"
}

output "virtual_network_address_space" {
  value       = azurerm_virtual_network.network.address_space
  description = "Address space of the Virtual Network"
}

output "subnets" {
  value       = { for k, v in azurerm_subnet.subnets : k => v }
  description = "The subnets deployed to the Virtual Network"
}

output "firewall_subnet" {
  value       = azurerm_subnet.firewall_subnet
  description = "The firewall subnet deployed to the Virtual Network"
}

output "bastion_subnet" {
  value       = azurerm_subnet.bastion_subnet
  description = "The bastion subnet deployed to the Virtual Network"
}

output "public_ip_prefixes" {
  value       = { for k, v in azurerm_public_ip_prefix.prefix : k => v }
  description = "The public IP prefixes to deploy"
}
