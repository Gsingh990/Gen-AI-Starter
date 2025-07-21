variable "name" {
  description = "The name of the Container Registry."
  type        = string
}

variable "location" {
  description = "The Azure region where the Container Registry will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the Container Registry will be deployed."
  type        = string
}

variable "sku" {
  description = "The SKU of the Container Registry."
  type        = string
  default     = "Standard"
}

variable "admin_enabled" {
  description = "Whether the admin user is enabled for the Container Registry."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to the Container Registry."
  type        = map(string)
  default     = {}
}
