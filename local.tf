locals {
  nsg_rules = distinct(flatten([
    for nsg in var.network_security_groups : [
      for nsg_rule in nsg.rules : {
        nsg_name                     = nsg.name
        rule_name                    = nsg_rule.name
        resource_group_name          = nsg.resource_group_name
        description                  = nsg_rule.description
        priority                     = nsg_rule.priority
        direction                    = nsg_rule.direction
        access                       = nsg_rule.access
        protocol                     = nsg_rule.protocol
        source_port_ranges           = nsg_rule.source_port_ranges
        source_port_range            = nsg_rule.source_port_range
        destination_port_ranges      = nsg_rule.destination_port_ranges
        destination_port_range       = nsg_rule.destination_port_range
        source_address_prefix        = nsg_rule.source_address_prefix
        source_address_prefixes      = nsg_rule.source_address_prefixes
        destination_address_prefix   = nsg_rule.destination_address_prefix
        destination_address_prefixes = nsg_rule.destination_address_prefixes
      }
  ]]))

  routes = distinct(flatten([
    for route_table in var.route_tables : [
      for route in route_table.routes : {
        route_table_name       = route_table.name
        route_name             = route.name
        resource_group_name    = route_table.resource_group_name
        address_prefix         = route.address_prefix
        next_hop_type          = route.next_hop_type
        next_hop_in_ip_address = route.next_hop_in_ip_address
      }
  ]]))

  bastion_nsg_rules = [
    {
      rule_name                    = "nsgsr-in-allow-client-443"
      resource_group_name          = var.resource_group_name
      description                  = "Allow internet inbound traffic on 443"
      priority                     = 120
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "443"
      destination_port_ranges      = null
      source_address_prefix        = var.bastion_network_security_group_allowed_ips.ip_range
      source_address_prefixes      = var.bastion_network_security_group_allowed_ips.ip_ranges
      destination_address_prefix   = "*"
      destination_address_prefixes = null
    },
    {
      rule_name                    = "nsgsr-in-allow-GatewayManager-443"
      resource_group_name          = var.resource_group_name
      description                  = "Allow GatewayManager inbound traffic on 443"
      priority                     = 130
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "443"
      destination_port_ranges      = null
      source_address_prefix        = "GatewayManager"
      source_address_prefixes      = null
      destination_address_prefix   = "*"
      destination_address_prefixes = null
    },
    {
      rule_name                    = "nsgsr-in-allow-AzureLoadBalancer-443"
      resource_group_name          = var.resource_group_name
      description                  = "Allow AzureLoadBalancer inbound traffic on 443"
      priority                     = 140
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "443"
      destination_port_ranges      = null
      source_address_prefix        = "AzureLoadBalancer"
      source_address_prefixes      = null
      destination_address_prefix   = "*"
      destination_address_prefixes = null
    },
    {
      rule_name                    = "nsgsr-in-allow-VirtualNetwork-8080-5701"
      resource_group_name          = var.resource_group_name
      description                  = "Allow VirtualNetwork inbound traffic on 8080 and 5701"
      priority                     = 150
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "*"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = null
      destination_port_ranges      = ["8080", "5701"]
      source_address_prefix        = "VirtualNetwork"
      source_address_prefixes      = null
      destination_address_prefix   = "VirtualNetwork"
      destination_address_prefixes = null
    },
    {
      rule_name                    = "nsgsr-in-deny-any-any"
      resource_group_name          = var.resource_group_name
      description                  = "Deny all inbound traffic"
      priority                     = 4000
      direction                    = "Inbound"
      access                       = "Deny"
      protocol                     = "*"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "*"
      destination_port_ranges      = null
      source_address_prefix        = "*"
      source_address_prefixes      = null
      destination_address_prefix   = "*"
      destination_address_prefixes = null
    },
    {
      rule_name                    = "nsgsr-out-allow-VirtualNetwork-22-3389"
      resource_group_name          = var.resource_group_name
      description                  = "Allow VirtualNetwork outbound traffic on 22 and 3389"
      priority                     = 120
      direction                    = "Outbound"
      access                       = "Allow"
      protocol                     = "*"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = null
      destination_port_ranges      = ["22", "3389"]
      source_address_prefix        = "*"
      source_address_prefixes      = null
      destination_address_prefix   = "VirtualNetwork"
      destination_address_prefixes = null
    },
    {
      rule_name                    = "nsgsr-out-allow-AzureCloud-443"
      resource_group_name          = var.resource_group_name
      description                  = "Allow AzureCloud outbound traffic on 443"
      priority                     = 130
      direction                    = "Outbound"
      access                       = "Allow"
      protocol                     = "*"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "443"
      destination_port_ranges      = null
      source_address_prefix        = "*"
      source_address_prefixes      = null
      destination_address_prefix   = "AzureCloud"
      destination_address_prefixes = null
    },
    {
      rule_name                    = "nsgsr-out-allow-VirtualNetwork-8080-5701"
      resource_group_name          = var.resource_group_name
      description                  = "Allow VirtualNetwork outbound traffic on 8080 and 5701"
      priority                     = 140
      direction                    = "Outbound"
      access                       = "Allow"
      protocol                     = "*"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = null
      destination_port_ranges      = ["8080", "5701"]
      source_address_prefix        = "VirtualNetwork"
      source_address_prefixes      = null
      destination_address_prefix   = "VirtualNetwork"
      destination_address_prefixes = null
    },
    {
      rule_name                    = "nsgsr-out-allow-Internet-80"
      resource_group_name          = var.resource_group_name
      description                  = "Allow Internet outbound traffic on 80"
      priority                     = 150
      direction                    = "Outbound"
      access                       = "Allow"
      protocol                     = "*"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "80"
      destination_port_ranges      = null
      source_address_prefix        = "*"
      source_address_prefixes      = null
      destination_address_prefix   = "Internet"
      destination_address_prefixes = null
    },
    {
      rule_name                    = "nsgsr-out-deny-any-any"
      resource_group_name          = var.resource_group_name
      description                  = "Deny all outbound traffic"
      priority                     = 4000
      direction                    = "Outbound"
      access                       = "Deny"
      protocol                     = "*"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "*"
      destination_port_ranges      = null
      source_address_prefix        = "*"
      source_address_prefixes      = null
      destination_address_prefix   = "*"
      destination_address_prefixes = null
    }
  ]
}
