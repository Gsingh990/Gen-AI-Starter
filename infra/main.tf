terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "3c42098f-375b-47ae-9727-1b0014b0d232"
}

data "azurerm_client_config" "current" {}

module "resource_group" {
  source   = "./modules/resource_group"
  name     = var.resource_group_name
  location = var.location
  tags     = var.common_tags
}

module "keyvault" {
  source                  = "./modules/keyvault"
  key_vault_name          = "${var.resource_group_name}-kv"
  location                = var.location
  resource_group_name     = var.resource_group_name
  tenant_id               = data.azurerm_client_config.current.tenant_id
  openai_api_key          = var.openai_api_key
  openai_endpoint         = var.openai_endpoint
  aks_identity_principal_id = module.aks.aks_managed_identity_principal_id
}
