resource "azurerm_network_security_group" "nsg" {
  for_each            = { for k in var.network_security_groups : k.name => k if k != null }
  name                = each.key
  resource_group_name = each.value["resource_group_name"]
  location            = var.location
  tags                = var.tags
}

resource "azurerm_network_security_rule" "nsg_rules" {
  for_each                     = { for k in local.nsg_rules : "${k.rule_name}-${k.nsg_name}-${k.resource_group_name}" => k if k != null }
  name                         = each.value["rule_name"]
  description                  = each.value["description"]
  priority                     = each.value["priority"]
  direction                    = each.value["direction"]
  access                       = each.value["access"]
  protocol                     = each.value["protocol"]
  source_port_ranges           = each.value["source_port_ranges"]
  source_port_range            = each.value["source_port_range"]
  destination_port_ranges      = each.value["destination_port_ranges"]
  destination_port_range       = each.value["destination_port_range"]
  source_address_prefixes      = each.value["source_address_prefixes"]
  source_address_prefix        = each.value["source_address_prefix"]
  destination_address_prefixes = each.value["destination_address_prefixes"]
  destination_address_prefix   = each.value["destination_address_prefix"]
  resource_group_name          = each.value["resource_group_name"]
  network_security_group_name  = azurerm_network_security_group.nsg[(each.value["nsg_name"])].name
}

resource "azurerm_monitor_diagnostic_setting" "network_security_group_diagnostics" {
  for_each                   = { for k in var.network_security_groups : k.name => k if k != null }
  name                       = "${var.log_analytics_workspace_name}-security-logging"
  target_resource_id         = azurerm_network_security_group.nsg[(each.key)].id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs.id

  log {
    category = "NetworkSecurityGroupEvent"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "NetworkSecurityGroupRuleCounter"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }
}

resource "azurerm_network_watcher_flow_log" "network" {
  for_each                  = { for k in var.network_security_groups : k.name => k if k != null }
  name                      = each.key
  network_watcher_name      = var.network_watcher_name
  resource_group_name       = var.network_watcher_resource_group_name
  network_security_group_id = azurerm_network_security_group.nsg[(each.key)].id
  storage_account_id        = data.azurerm_storage_account.logs.id
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = 365
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = data.azurerm_log_analytics_workspace.logs.workspace_id
    workspace_region      = data.azurerm_log_analytics_workspace.logs.location
    workspace_resource_id = data.azurerm_log_analytics_workspace.logs.id
    interval_in_minutes   = 10
  }
  tags = var.tags
}

resource "azurerm_route_table" "route_table" {
  for_each                      = { for k in var.route_tables : k.name => k if k != null }
  name                          = each.key
  location                      = var.location
  resource_group_name           = each.value["resource_group_name"]
  disable_bgp_route_propagation = each.value["disable_bgp_route_propagation"]
  tags                          = var.tags
}

resource "azurerm_route" "routes" {
  for_each               = { for k in local.routes : "${k.route_name}-${k.route_table_name}-${k.resource_group_name}" => k if k != null }
  name                   = each.value["route_name"]
  address_prefix         = each.value["address_prefix"]
  next_hop_type          = each.value["next_hop_type"]
  next_hop_in_ip_address = each.value["next_hop_in_ip_address"]
  resource_group_name    = each.value["resource_group_name"]
  route_table_name       = azurerm_route_table.route_table[(each.value["route_table_name"])].name
}

resource "azurerm_virtual_network" "network" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.virtual_network_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each                                      = { for k in var.subnets : k.name => k if k != null }
  name                                          = each.key
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.network.name
  address_prefixes                              = each.value.address_prefixes
  service_endpoints                             = each.value.service_endpoints
  service_endpoint_policy_ids                   = each.value.service_endpoint_policy_ids
  private_endpoint_network_policies_enabled     = each.value.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled

  dynamic "delegation" {
    for_each = each.value.delegation == null ? [] : [1]
    content {
      name = "delegation"

      service_delegation {
        name    = each.value.delegation
        actions = each.value.delegation_actions
      }
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_join" {
  for_each                  = { for k in var.subnets : k.name => k if k != null }
  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.value.network_security_group_reference].id
}

resource "azurerm_subnet_route_table_association" "route_table_join" {
  for_each       = { for k in var.subnets : k.name => k if k != null }
  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = azurerm_route_table.route_table[each.value.route_table_reference].id
}

resource "azurerm_subnet" "firewall_subnet" {
  name                                          = "AzureFirewallSubnet"
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.network.name
  address_prefixes                              = var.firewall_subnet_address_prefixes
  service_endpoints                             = var.firewall_subnet_service_endpoints
  service_endpoint_policy_ids                   = length(var.firewall_subnet_service_endpoint_policy_ids) == 0 ? null : var.firewall_subnet_service_endpoint_policy_ids
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
}

resource "azurerm_subnet" "bastion_subnet" {
  name                                          = "AzureBastionSubnet"
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.network.name
  address_prefixes                              = var.bastion_subnet_address_prefixes
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
}

resource "azurerm_monitor_diagnostic_setting" "virtual_network_diagnostics" {
  name                       = "${var.log_analytics_workspace_name}-security-logging"
  target_resource_id         = azurerm_virtual_network.network.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs.id

  log {
    category = "VMProtectionAlerts"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }
}

resource "azurerm_public_ip_prefix" "prefix" {
  for_each            = { for k in var.public_ip_prefixes : k.name => k if k != null }
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  ip_version          = each.value.ip_version
  prefix_length       = each.value.prefix_length
  zones               = [1, 2, 3]
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_vnet_link" {
  count                 = var.private_dns_zone.enable_link == true ? 1 : 0
  name                  = var.virtual_network_name
  resource_group_name   = var.private_dns_zone.resource_group_name
  private_dns_zone_name = var.private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.network.id
}
