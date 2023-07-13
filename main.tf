#-------------------------------
# Local Declarations
#-------------------------------
locals { 
  
  install_ad_command   = "Install-WindowsFeature -Name AD-Domain-Services,DNS -IncludeManagementTools"
  password_command     = "$password = ConvertTo-SecureString ${var.admin_password} -AsPlainText -Force"
  configure_ad_command = "Install-ADDSForest -DomainName ${var.active_directory_domain} -CreateDnsDelegation:$false -DomainMode 7 -DomainNetbiosName ${var.active_directory_netbios_name} -ForestMode 7 -InstallDns:$true -SafeModeAdministratorPassword $password  -Force:$true"
  shutdown_command     = "shutdown -r -t 0"
  exit_code_hack       = "exit 0"
  powershell_ad_command   = "${local.install_ad_command}; ${local.password_command}; ${local.configure_ad_command}; ${local.exit_code_hack}"
  
}

resource "azurerm_resource_group" "rg" {
  name     =  "${var.Project}-RG"
  location = "eastus2"
}

resource "azurerm_virtual_network" "VNet" {
  name                = "${var.Project}-network"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.2.10", "8.8.8.8"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "SubNet1" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.VNet.name
  address_prefixes     = ["10.0.2.0/24"]
}

## Domain Controller 
resource "azurerm_public_ip" "DC-Public-IP" {
  name                = "DCPublicIp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  #availability_zone   = "No-Zone"
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "NetInt-DC" {
  name                = "DC-${var.Project}-NIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  enable_ip_forwarding          = true
  #enable_accelerated_networking = trueyes
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SubNet1.id
    public_ip_address_id          = azurerm_public_ip.DC-Public-IP.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.10"
    
  }
}

resource "azurerm_windows_virtual_machine" "DC" {
  name                       = "DC-${var.Project}-VM"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  size                       = "Standard_A4_v2"
  admin_username             = var.admin_username
  admin_password             = var.admin_password
  provision_vm_agent         = true
  allow_extension_operations = true
  network_interface_ids = [
    azurerm_network_interface.NetInt-DC.id,
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
  name                       = "ad-forest-creation"
  virtual_machine_id         = azurerm_windows_virtual_machine.DC.id
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
