module "openai" {
  source                  = "./modules/openai"
  account_name            = var.openai_account_name
  location                = module.resource_group.location
  resource_group_name     = module.resource_group.name
  model_deployment_name   = var.openai_model_deployment_name
  model_name              = "gpt-4o"
  model_version           = "2024-08-06"
  embedding_deployment_name = var.openai_embedding_deployment_name
  embedding_name          = "text-embedding-ada-002"
  embedding_version       = "2"
  tags                    = var.common_tags
}