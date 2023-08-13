resource "azurerm_resource_group" "main" {
  count    = var.use_custom_rg ? 0 : 1
  name     = var.use_custom_resource_prefix_name ? "${var.rg_name}" : "RG_${var.rg_name}"
  location = var.location
}