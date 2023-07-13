resource "azurerm_resource_group" "main" {
  count    = var.rg_config.create_rg ? 1 : 0
  name     = "RG_${var.rg_config.name}"
  location = var.rg_config.location
}