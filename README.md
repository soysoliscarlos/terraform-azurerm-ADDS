# terraform-azurerm-ADDS

[_Click here to see Readme in Spanish_](https://github.com/soysoliscarlos/terraform-azurerm-ADDS/blob/main/README-ES.md)

Terraform module to create a VM in Azure with Active Directory Domain Controller (AD DC)

NOTE: For now this terraform module should be used only for development environments. DO NOT USE FOR PRODUCTION ENVIRONMENTS

## Create Resource Group, Virtual Network and VM AD DC with default vaules

```terraform
module "ADDS" {
  source  = "soysoliscarlos/ADDS/azurerm"
  version = "0.0.20"
}
```

### Default values

#### VM Credentials

- username = "azureadmin"
- password = "123456abcDEF."

#### AD DC INFORMATION

- active_directory_domain = "ADDS.local"
- active_directory_netbios_name = "ADDS"

#### Resource Group

- name = "RG_ADDS"
- location = "eastus2"

#### Virtual Network

- name = "VNet_01"
- dns_servers = ["192.168.0.4"]
- address_space = ["192.168.0.0/24"]

##### Subnet

- name = "default"
- address_prefixes = ["192.168.0.0/24"]

##### Network Security Group

- name = "NSG_ADDS"

#### Virtual Machine

- name = "VM_01"
- subnet = "default"
- private_ip_address = "192.168.0.4"

## Resource group

### Create custom Resource Group

```terraform
module "ADDS" {
  source  = "soysoliscarlos/ADDS/azurerm"
  version = "0.0.20"
  # Create CustomResource Group
  use_custom_rg = true
  rg_name = "ADDS" # with the prefix "RG_" the final name will be prefix ´variable name; ex "RG_ADDS"
  rg_location = "eastus2"
}
```

### Use Data source of a Resource Group

```terraform
data "azurerm_resource_group" "default" {
  name = "RG_ADDS"
}

module "ADDS" {
    source  = "soysoliscarlos/ADDS/azurerm"
  version = "0.0.20"
  # Create CustomResource Group
  use_custom_rg = true
  rg_data = data.azurerm_resource_group.rg
}
```

## Create Resource Group, Virtual Network and VM AD DC with custom vaules

```terraform
module "ADDS" {
    source  = "soysoliscarlos/ADDS/azurerm"
  version = "0.0.20"
  # Create Custom Resource Group
  use_custom_rg = true
  rg_name = "ADDS" # with the prefix "RG_" the final name will be prefix ´variable name; ex "RG_ADDS"
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
  # Network Security Group
  nsg_name = "ADDS"

  # Create Virtual Machine
  vm_config = {
    create_vm = true
    name = "01"
    subnet = "default"
    private_ip_address = "192.168.0.4"
  }

  "admin_username" = "azureadmin"
  "admin_password" = "123456abcDEF." 
  "active_directory_domain" = "ADDS.local"
  "active_directory_netbios_name" = "ADDS"
}
```

## Default Prefix

Bu default, all resources have the following prefixes:

| Resource       |  Prefix  |
|----------------|--------:|
| Resource group | RG_    |
| Virtual Network | VNet_ |
| Network Security Group| NSG_ |
| Public IP | PIP_ |
| Network Interface | NIC_ |
|Virtual Machine | VM_ |

If you don't want to use the default prefixes, you can the following variable into the module

```terraform
use_custom_resource_prefix_name = true
```

## Output content

To know what is the public IP of the virtual machine, add the follow block:

```terraform
output "Public-IP" {
  value = "${module.ADDS.publicip}"
}
```
