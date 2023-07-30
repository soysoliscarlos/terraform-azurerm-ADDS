resource "azurerm_resource_group" "main" {
  count    = var.use_custom_rg ? 0 : 1
  name     = "RG_${var.rg_name}"
  location = var.location
}