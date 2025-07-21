output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "openai_account_name" {
  value = azurerm_cognitive_account.openai.name
}

output "openai_model_deployment_name" {
  value = azurerm_cognitive_deployment.openai_model.name
}

output "openai_embedding_deployment_name" {
  value = azurerm_cognitive_deployment.embedding_model.name
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}

output "bastion_public_ip" {
  value = azurerm_public_ip.bastion_ip.ip_address
}
