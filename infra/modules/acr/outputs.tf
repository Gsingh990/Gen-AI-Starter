output "id" {
  value       = azurerm_container_registry.acr.id
  description = "The ID of the Container Registry."
}

output "name" {
  value       = azurerm_container_registry.acr.name
  description = "The name of the Container Registry."
}

output "login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "The login server of the Container Registry."
}
