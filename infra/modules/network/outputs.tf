output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The ID of the virtual network."
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "The name of the virtual network."
}

output "aks_subnet_id" {
  value       = azurerm_subnet.aks_subnet.id
  description = "The ID of the AKS subnet."
}

output "azure_bastion_subnet_id" {
  value       = azurerm_subnet.azure_bastion_subnet.id
  description = "The ID of the Azure Bastion subnet."
}
