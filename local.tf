locals {
  nsg_rules = distinct(flatten([
    for nsg in var.network_security_groups : [
      for nsg_rule in nsg.rules : {
        nsg_name                     = nsg.name
        rule_name                    = nsg_rule.name
        resource_group_name          = nsg.resource_group_name
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
}
