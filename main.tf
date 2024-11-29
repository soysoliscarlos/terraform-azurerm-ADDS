
## Domain Controller 
resource "azurerm_public_ip" "main" {
  name                = var.use_custom_resource_prefix_name ? "${var.vm_config.name}" : "PIP_${var.vm_config.name}"
  resource_group_name = local.rgname
  location            = local.rglocation
  #availability_zone   = "No-Zone"
  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_network_interface" "main" {
  count                = var.vm_config.create_vm ? 1 : 0
  name                 = var.use_custom_resource_prefix_name ? "${var.vm_config.name}" : "NIC_${var.vm_config.name}"
  location             = local.rglocation
  resource_group_name  = local.rgname
  enable_ip_forwarding = true
  #enable_accelerated_networking = trueyes

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main[var.vm_config.subnet].id
    public_ip_address_id          = azurerm_public_ip.main.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vm_config.private_ip_address
  }
}

data "azurerm_virtual_machine" "main" {
  count               = var.vm_config.create_vm ? 0 : 1
  name                = local.vmname
  resource_group_name = local.rgname
}
resource "azurerm_windows_virtual_machine" "main" {
  count                      = var.vm_config.create_vm ? 1 : 0
  name                       = var.use_custom_resource_prefix_name ? "${var.vm_config.name}" : "VM-${var.vm_config.name}"
  computer_name              = var.vm_config.name
  resource_group_name        = local.rgname
  location                   = local.rglocation
  size                       = "Standard_A4_v2"
  admin_username             = var.admin_username
  admin_password             = var.admin_password
  provision_vm_agent         = true
  allow_extension_operations = true
  network_interface_ids = [
    azurerm_network_interface.main[0].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

#---------------------------------------
# Promote Domain Controller
#---------------------------------------
resource "azurerm_virtual_machine_extension" "adforest" {
  count                      = var.vm_config.create_vm ? 1 : 0
  name                       = "ad-forest-creation"
  virtual_machine_id         = azurerm_windows_virtual_machine.main[0].id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"${local.powershell_ad_command}\""
    }
  SETTINGS
}
