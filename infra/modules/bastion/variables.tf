variable "public_ip_name" {
  description = "The name of the public IP address for the Bastion host."
  type        = string
}

variable "bastion_host_name" {
  description = "The name of the Bastion host."
  type        = string
}

variable "location" {
  description = "The Azure region where the Bastion host will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the Bastion host will be deployed."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the Bastion host will be deployed."
  type        = string
}

variable "sku" {
  description = "The SKU of the Bastion host."
  type        = string
  default     = "Standard"
}

variable "scale_units" {
  description = "The number of scale units for the Bastion host."
  type        = number
  default     = 2
}

variable "copy_paste_enabled" {
  description = "Whether copy/paste is enabled for the Bastion host."
  type        = bool
  default     = true
}

variable "file_copy_enabled" {
  description = "Whether file copy is enabled for the Bastion host."
  type        = bool
  default     = false
}

variable "ip_connect_enabled" {
  description = "Whether IP connect is enabled for the Bastion host."
  type        = bool
  default     = false
}

variable "kerberos_enabled" {
  description = "Whether Kerberos is enabled for the Bastion host."
  type        = bool
  default     = false
}

variable "session_recording_enabled" {
  description = "Whether session recording is enabled for the Bastion host."
  type        = bool
  default     = false
}

variable "shareable_link_enabled" {
  description = "Whether shareable link is enabled for the Bastion host."
  type        = bool
  default     = false
}

variable "tunneling_enabled" {
  description = "Whether tunneling is enabled for the Bastion host."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to the Bastion host resources."
  type        = map(string)
  default     = {}
}
