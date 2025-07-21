module "acr" {
  source              = "./modules/acr"
  name                = "genaistarterstackacr"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tags                = var.common_tags
}