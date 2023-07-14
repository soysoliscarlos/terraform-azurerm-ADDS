

resource "azurerm_virtual_network" "main" {
  count               = var.vnet_config.create_vnet ? 1 : 0
  name                = "VNet_${var.vnet_config.name}"
  address_space       = var.vnet_config.address_space
  location            = local.rglocation
  resource_group_name = local.rgname
  dns_servers         = var.vnet_config.dns_servers
  depends_on = [
    azurerm_resource_group.main,
  ]
}

resource "azurerm_subnet" "main" {
  for_each         = { for each in var.subnets_config : each.name => each }
  name             = each.value.name
  address_prefixes = each.value.address_prefixes
  #enforce_private_link_endpoint_network_policies = true
  resource_group_name  = local.rgname
  virtual_network_name = azurerm_virtual_network.main[0].name

  depends_on = [
    azurerm_virtual_network.main,
  ]
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "azurerm_network_security_group" "main" {
  name                = "NSG_01"
  location            = local.rglocation
  resource_group_name = local.rgname

  security_rule {
    name                       = "AllowRDPInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "${chomp(data.http.myip.response_body)}"
    destination_address_prefix = "*"
  }
}