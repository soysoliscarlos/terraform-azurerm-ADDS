#-------------------------------
# Local Declarations
#-------------------------------
locals {

  install_ad_command    = "Install-WindowsFeature -Name AD-Domain-Services,DNS -IncludeManagementTools"
  password_command      = "$password = ConvertTo-SecureString ${var.admin_password} -AsPlainText -Force"
  configure_ad_command  = "Install-ADDSForest -DomainName ${var.active_directory_domain} -CreateDnsDelegation:$false -DomainMode 7 -DomainNetbiosName ${var.active_directory_netbios_name} -ForestMode 7 -InstallDns:$true -SafeModeAdministratorPassword $password  -Force:$true"
  shutdown_command      = "shutdown -r -t 0"
  exit_code_hack        = "exit 0"
  powershell_ad_command = "${local.install_ad_command}; ${local.password_command}; ${local.configure_ad_command}; ${local.exit_code_hack}"
  rglocation = try(
    "${azurerm_resource_group.main[0].location}",
    "${var.rg_data.location}"
  )
  rgname = try(
    "${azurerm_resource_group.main[0].name}",
    "${var.rg_data.name}"
  )
  rgdata = try(
    "${azurerm_resource_group.main}",
    "${var.rg_data}"
  )
  vmname = try(
    "${azurerm_windows_virtual_machine.main[0].id}",
    "${var.virtual_machine_name}"
  )
}