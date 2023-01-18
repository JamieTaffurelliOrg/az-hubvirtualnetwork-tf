data "azurerm_virtual_network" "peered_networks" {
  for_each            = { for k in var.peerings : "${azurerm_virtual_network.network.name}-${k.remote_vnet_name}" => k if k != null }
  provider            = azurerm.spoke
  name                = each.value["remote_vnet_name"]
  resource_group_name = each.value["remote_vnet_resource_group_name"]
}

data "azurerm_log_analytics_workspace" "logs" {
  provider            = azurerm.logs
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group_name
}

data "azurerm_storage_account" "logs" {
  provider            = azurerm.logs
  name                = var.storage_account_name
  resource_group_name = var.storage_account_resource_group_name
}
