resource "azurerm_public_ip" "nat_gateway_ip" {
  name                = "${var.resource_group_name}-nat-gateway-ip"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
  tags                = var.common_tags
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name                = "${var.resource_group_name}-nat-gateway"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  sku_name            = "Standard"
  idle_timeout_in_minutes = 4
  tags                = var.common_tags
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_gateway_ip.id
}
