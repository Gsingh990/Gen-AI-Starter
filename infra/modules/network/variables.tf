variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
}

variable "location" {
  description = "The Azure region where the network resources will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the network resources will be deployed."
  type        = string
}

variable "aks_subnet_name" {
  description = "The name of the subnet for the AKS cluster."
  type        = string
}

variable "aks_subnet_address_prefix" {
  description = "The address prefix for the AKS subnet."
  type        = string
}

variable "azure_bastion_subnet_address_prefix" {
  description = "The address prefix for the Azure Bastion subnet."
  type        = string
}

variable "nat_gateway_id" {
  description = "The ID of the NAT Gateway to associate with the AKS subnet."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to the network resources."
  type        = map(string)
  default     = {}
}
