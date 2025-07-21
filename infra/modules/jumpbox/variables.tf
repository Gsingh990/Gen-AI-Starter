variable "nic_name" {
  description = "The name of the network interface for the jumpbox VM."
  type        = string
}

variable "vm_name" {
  description = "The name of the jumpbox VM."
  type        = string
}

variable "location" {
  description = "The Azure region where the jumpbox VM will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the jumpbox VM will be deployed."
  type        = string
}

variable "vm_size" {
  description = "The size of the Virtual Machine for the jumpbox."
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "The admin username for the jumpbox VM."
  type        = string
}

variable "ssh_public_key" {
  description = "The SSH public key for the jumpbox VM."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the jumpbox VM will be deployed."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to the jumpbox resources."
  type        = map(string)
  default     = {}
}
