variable "account_name" {
  description = "The name of the Azure OpenAI account."
  type        = string
}

variable "location" {
  description = "The Azure region where the OpenAI resources will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the OpenAI resources will be deployed."
  type        = string
}

variable "model_deployment_name" {
  description = "The name of the Azure OpenAI model deployment."
  type        = string
}

variable "model_name" {
  description = "The name of the OpenAI model to deploy."
  type        = string
}

variable "model_version" {
  description = "The version of the OpenAI model to deploy."
  type        = string
}

variable "embedding_deployment_name" {
  description = "The name of the Azure OpenAI embedding model deployment."
  type        = string
}

variable "embedding_name" {
  description = "The name of the OpenAI embedding model to deploy."
  type        = string
}

variable "embedding_version" {
  description = "The version of the OpenAI embedding model to deploy."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to the OpenAI resources."
  type        = map(string)
  default     = {}
}
