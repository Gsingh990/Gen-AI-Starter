variable "key_vault_name" {
  type        = string
  description = "The name of the Azure Key Vault."
}

variable "location" {
  type        = string
  description = "The Azure region where the Key Vault will be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the Key Vault will be created."
}

variable "tenant_id" {
  type        = string
  description = "The tenant ID of the Azure subscription."
}

variable "openai_api_key" {
  type        = string
  description = "The API key for the Azure OpenAI service."
  sensitive   = true
}

variable "openai_endpoint" {
  type        = string
  description = "The endpoint for the Azure OpenAI service."
  sensitive   = true
}

variable "aks_identity_principal_id" {
  type        = string
  description = "The principal ID of the AKS cluster's managed identity."
}