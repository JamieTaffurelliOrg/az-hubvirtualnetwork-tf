# az-hubvirtualnetwork-tf

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.20 |
| <a name="provider_azurerm.logs"></a> [azurerm.logs](#provider\_azurerm.logs) | ~> 3.20 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.network_security_group_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.virtual_network_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.nsg_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_watcher_flow_log.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_watcher_flow_log) | resource |
| [azurerm_public_ip_prefix.prefix](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip_prefix) | resource |
| [azurerm_route.routes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.route_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.bastion_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.firewall_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.nsg_join](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.route_table_join](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_log_analytics_workspace.logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_storage_account.logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_subnet_address_prefixes"></a> [bastion\_subnet\_address\_prefixes](#input\_bastion\_subnet\_address\_prefixes) | IP range of the Azure Bastion subnet | `list(string)` | n/a | yes |
| <a name="input_firewall_subnet_address_prefixes"></a> [firewall\_subnet\_address\_prefixes](#input\_firewall\_subnet\_address\_prefixes) | IP range of the Azure Firewall subnet | `list(string)` | n/a | yes |
| <a name="input_firewall_subnet_service_endpoint_policy_ids"></a> [firewall\_subnet\_service\_endpoint\_policy\_ids](#input\_firewall\_subnet\_service\_endpoint\_policy\_ids) | Service endpoint policies to attach to Azure Firewall subnet | `list(string)` | `[]` | no |
| <a name="input_firewall_subnet_service_endpoints"></a> [firewall\_subnet\_service\_endpoints](#input\_firewall\_subnet\_service\_endpoints) | Service endpoints to attach to Azure Firewall subnet | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of the Virtual Network | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Name of Log Analytics Workspace to send diagnostics | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | Resource Group of Log Analytics Workspace to send diagnostics | `string` | n/a | yes |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | Network Security Groups to deploy | <pre>list(object(<br>    {<br>      name                = string<br>      resource_group_name = string<br>      rules = list(object(<br>        {<br>          priority                     = number<br>          direction                    = string<br>          access                       = string<br>          protocol                     = string<br>          source_port_ranges           = optional(list(string))<br>          source_port_range            = optional(string)<br>          destination_port_ranges      = optional(list(string))<br>          destination_port_range       = optional(string)<br>          source_address_prefix        = optional(string)<br>          source_address_prefixes      = optional(list(string))<br>          destination_address_prefix   = optional(string)<br>          destination_address_prefixes = optional(list(string))<br>        }<br>      ))<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_network_watcher_name"></a> [network\_watcher\_name](#input\_network\_watcher\_name) | Name of Network Watcher to send diagnostics | `string` | n/a | yes |
| <a name="input_network_watcher_resource_group_name"></a> [network\_watcher\_resource\_group\_name](#input\_network\_watcher\_resource\_group\_name) | Resource Group of Network Watcher to send diagnostics | `string` | n/a | yes |
| <a name="input_public_ip_prefixes"></a> [public\_ip\_prefixes](#input\_public\_ip\_prefixes) | Public IP prefixes to deploy | <pre>list(object(<br>    {<br>      name          = string<br>      ip_version    = optional(string, "IPv4")<br>      prefix_length = number<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group name to deploy to | `string` | n/a | yes |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | Route Tables to deploy | <pre>list(object(<br>    {<br>      name                          = string<br>      resource_group_name           = string<br>      disable_bgp_route_propagation = optional(bool, true)<br>      routes = list(object(<br>        {<br>          address_prefix         = number<br>          next_hop_type          = string<br>          next_hop_in_ip_address = optional(string)<br>        }<br>      ))<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Name of storage account to send diagnostics | `string` | n/a | yes |
| <a name="input_storage_account_resource_group_name"></a> [storage\_account\_resource\_group\_name](#input\_storage\_account\_resource\_group\_name) | Resource Group of storage account to send diagnostics | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets to deploy | <pre>list(object(<br>    {<br>      name                                          = string<br>      address_prefixes                              = list(string)<br>      service_endpoints                             = optional(list(string))<br>      service_endpoint_policy_ids                   = optional(list(string))<br>      private_endpoint_network_policies_enabled     = optional(bool, true)<br>      private_link_service_network_policies_enabled = optional(bool, true)<br>      network_security_group_reference              = string<br>      route_table_reference                         = string<br>    }<br>  ))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply | `map(string)` | n/a | yes |
| <a name="input_virtual_network_address_space"></a> [virtual\_network\_address\_space](#input\_virtual\_network\_address\_space) | Address space of the Virtual Network to deploy | `list(string)` | n/a | yes |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the Virtual Network to deploy | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_subnet"></a> [bastion\_subnet](#output\_bastion\_subnet) | The bastion subnet deployed to the Virtual Network |
| <a name="output_firewall_subnet"></a> [firewall\_subnet](#output\_firewall\_subnet) | The firewall subnet deployed to the Virtual Network |
| <a name="output_network_security_group_id"></a> [network\_security\_group\_id](#output\_network\_security\_group\_id) | Resource IDs of the Network Security Groups |
| <a name="output_public_ip_prefixes"></a> [public\_ip\_prefixes](#output\_public\_ip\_prefixes) | The public IP prefixes to deploy |
| <a name="output_route_table_id"></a> [route\_table\_id](#output\_route\_table\_id) | Resource IDs of the Route Tables |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | The subnets deployed to the Virtual Network |
| <a name="output_virtual_network_address_space"></a> [virtual\_network\_address\_space](#output\_virtual\_network\_address\_space) | Address space of the Virtual Network |
| <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id) | Resource ID of the Virtual Network |
<!-- END_TF_DOCS -->
