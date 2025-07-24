resource "azurerm_public_ip" "bastion_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "bastion" {
  name                      = var.bastion_host_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  sku                       = var.sku
  scale_units               = var.scale_units
  copy_paste_enabled        = var.copy_paste_enabled
  file_copy_enabled         = var.file_copy_enabled
  ip_connect_enabled        = var.ip_connect_enabled
  kerberos_enabled          = var.kerberos_enabled
  session_recording_enabled = var.session_recording_enabled
  shareable_link_enabled    = var.shareable_link_enabled
  tunneling_enabled         = true
  tags                      = var.tags

  ip_configuration {
    name                 = "IpConf"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }
}
