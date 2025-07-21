module "jumpbox" {
  source              = "./modules/jumpbox"
  nic_name            = "${var.resource_group_name}-jumpbox-nic"
  vm_name             = "${var.resource_group_name}-jumpbox-vm"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  admin_username      = var.jumpbox_admin_username
  ssh_public_key      = var.jumpbox_ssh_public_key
  subnet_id           = module.network.aks_subnet_id
  tags                = var.common_tags
}