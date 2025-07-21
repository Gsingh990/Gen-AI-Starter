output "account_id" {
  value       = azurerm_cognitive_account.openai.id
  description = "The ID of the OpenAI account."
}

output "account_name" {
  value       = azurerm_cognitive_account.openai.name
  description = "The name of the OpenAI account."
}

output "model_deployment_name" {
  value       = azurerm_cognitive_deployment.openai_model.name
  description = "The name of the OpenAI model deployment."
}

output "embedding_deployment_name" {
  value       = azurerm_cognitive_deployment.embedding_model.name
  description = "The name of the OpenAI embedding model deployment."
}
