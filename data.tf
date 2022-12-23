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
