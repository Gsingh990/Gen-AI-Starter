output "bastion_host_id" {
  value       = azurerm_bastion_host.bastion.id
  description = "The ID of the Bastion host."
}

output "bastion_host_name" {
  value       = azurerm_bastion_host.bastion.name
  description = "The name of the Bastion host."
}

output "bastion_public_ip" {
  value       = azurerm_public_ip.bastion_ip.ip_address
  description = "The public IP address of the Bastion host."
}
