module "aks" {
  source              = "./modules/aks"
  cluster_name        = var.aks_cluster_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  dns_prefix          = var.aks_dns_prefix
  node_count          = 1
  vm_size             = "Standard_B2s"
  subnet_id           = module.network.aks_subnet_id
  tags                = var.common_tags
}