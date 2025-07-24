variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be deployed."
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources."
  type        = map(string)
  default     = {
    environment = "dev"
    project     = "GenAIStarterStack"
  }
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
  default     = "GenAI-VNet"
}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_name" {
  description = "The name of the subnet for the AKS cluster."
  type        = string
  default     = "AKSSubnet"
}

variable "aks_subnet_address_prefix" {
  description = "The address prefix for the AKS subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
  default     = "GenAI-AKS-Cluster"
}

variable "aks_dns_prefix" {
  description = "The DNS prefix for the AKS cluster."
  type        = string
  default     = "genaistarterstack"
}

variable "openai_account_name" {
  description = "The name of the Azure OpenAI account."
  type        = string
  default     = "genai-openai-account"
}

variable "openai_model_deployment_name" {
  description = "The name of the Azure OpenAI model deployment."
  type        = string
  default     = "gpt-4o"
}

variable "openai_embedding_deployment_name" {
  description = "The name of the Azure OpenAI embedding model deployment."
  type        = string
  default     = "text-embedding-ada-002"
}

variable "jumpbox_admin_username" {
  description = "The admin username for the jumpbox VM."
  type        = string
  default     = "azureuser"
}

variable "jumpbox_ssh_public_key" {
  description = "The SSH public key for the jumpbox VM."
  type        = string
  default     = "ssh-ed25519 AAAAC3NsaC1lZDI1NTE5AAAAII7gIGbBj+JvJVMraEscRfDOdoLbxnw6Nwy4IKljxrfJ gauravsingh@Gauravs-Mac-Book-Air.local"
}

variable "azure_bastion_subnet_address_prefix" {
  description = "The address prefix for the Azure Bastion subnet."
  type        = string
  default     = "10.0.2.0/26"
}

