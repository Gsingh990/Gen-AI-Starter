resource "azurerm_public_ip" "bastion_ip" {
  name                = "GenAI-VNet-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                      = "GenAI-VNet-bastion"
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  sku                       = "Standard"
  scale_units               = 2
  copy_paste_enabled        = true
  file_copy_enabled         = false
  ip_connect_enabled        = false
  kerberos_enabled          = false
  session_recording_enabled = false
  shareable_link_enabled    = false
  tunneling_enabled         = true

  ip_configuration {
    name                 = "IpConf"
    subnet_id            = azurerm_subnet.azure_bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }
}