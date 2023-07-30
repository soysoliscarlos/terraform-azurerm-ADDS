# terraform-azurerm-ADDC

Terraform module to create a VM in Azure with Active Directory Domain Controller (AD DC)

NOTE: For now this terraform module should be used only for development environments. DO NOT USE FOR PRODUCTION ENVIRONMENTS

## Create Resource Group, Virtual Network and VM AD DC with default vaules

```terraform
module "addc" {
  source    = "github.com/soysoliscarlos/terraform-azurerm-ADDC.git"
}
```

### Default values

#### VM Credentials

- username = "azureadmin"
- password = "123456abcDEF."

#### AD DC INFORMATION

- active_directory_domain = "addc.local"
- active_directory_netbios_name = "addc"

#### Resource Group

- name = "RG_addc"
- location = "eastus2"

#### Virtual Network

- name = "VNet_01"
- dns_servers = ["192.168.0.4"]
- address_space = ["192.168.0.0/24"]

##### Subnet

- name = "default"
- address_prefixes = ["192.168.0.0/24"]

#### Virtual Machine

- name = "VM_01"
- subnet = "default"
- private_ip_address = "192.168.0.4"

## Create Resource Group, Virtual Network, and AD DC with Pesonalized values

```terraform
module "addc" {
  source = "github.com/soysoliscarlos/terraform-azurerm-ADDC.git"
  # Create CustomResource Group
  use_custom_rg = true
  rg_name = "addc" # with the prefix "RG_" the final name will be prefix ´variable name; ex "RG_addc"
  rg_location = "eastus2"
  # Create Virtual Network
  vnet_config =
  {
      create_vnet = true
      name = "TEST"
      dns_servers = ["192.168.0.4"]
      address_space = ["192.168.0.0/24"]
    }
  # Crear Subnet
  subnets_config = [
     {
        name = "default"
        address_prefixes = ["192.168.0.0/24"]
    } 
  ]
  # Create Virtual Machine
  vm_config = {
    create_vm = true
    name = "01"
    subnet = "default"
    private_ip_address = "192.168.0.4"
  }

  "admin_username" = "azureadmin"
  "admin_password" = "123456abcDEF." 
  "active_directory_domain" = "addc.local"
  "active_directory_netbios_name" = "addc"
}
```

## Output content

To know what is the public IP, add the follow block:

```terraform
output "Public-IP" {
  value = "${module.addc.publicip}"
}
```
