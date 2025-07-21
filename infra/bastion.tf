module "bastion" {
  source              = "./modules/bastion"
  public_ip_name      = "GenAI-VNet-ip"
  bastion_host_name   = "GenAI-VNet-bastion"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.network.azure_bastion_subnet_id
  tags                = var.common_tags
}