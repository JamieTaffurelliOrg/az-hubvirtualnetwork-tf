terraform {
  required_providers {
    azurerm = {
      configuration_aliases = [azurerm.logs, azurerm.spoke]
      source                = "hashicorp/azurerm"
      version               = "~> 3.20"
    }
  }
  required_version = "~> 1.5.0"
}
