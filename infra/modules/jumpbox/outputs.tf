output "vm_id" {
  value       = azurerm_linux_virtual_machine.jumpbox_vm.id
  description = "The ID of the jumpbox VM."
}

output "vm_name" {
  value       = azurerm_linux_virtual_machine.jumpbox_vm.name
  description = "The name of the jumpbox VM."
}

output "private_ip_address" {
  value       = azurerm_linux_virtual_machine.jumpbox_vm.private_ip_address
  description = "The private IP address of the jumpbox VM."
}
