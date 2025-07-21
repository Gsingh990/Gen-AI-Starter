module "network" {
  source                          = "./modules/network"
  vnet_name                       = var.vnet_name
  vnet_address_space              = var.vnet_address_space
  location                        = module.resource_group.location
  resource_group_name             = module.resource_group.name
  aks_subnet_name                 = var.aks_subnet_name
  aks_subnet_address_prefix       = var.aks_subnet_address_prefix
  azure_bastion_subnet_address_prefix = var.azure_bastion_subnet_address_prefix
  tags                            = var.common_tags
}
