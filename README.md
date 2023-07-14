# terraform-azurerm-ADDC

Modulo para crear una VM con AD DC

# Crear Grupo de Recursos, Virtual Network y AD DC con valores por defecto

```
module "addc" {
  source  = "github.com/soysoliscarlos/terraform-azurerm-ADDC.git?ref=0.0.1""
}
```

## Default values

### VM Credentials

- username = "azureadmin"
- password = "123456abcDEF."

### AD DC INFORMATION

- active_directory_domain = "addc.local"
- active_directory_netbios_name = "addc"

### Resource Group

- name = "RG_01"
- location = "eastus2"

### Virtual Network

- name = "VNet_01"
- dns_servers = ["192.168.0.4"]
- address_space = ["192.168.0.0/24"]

#### Subnet

- name = "default"
- address_prefixes = ["192.168.0.0/24"]

### Virtual Machine

- name = "VM_01"
- subnet = "default"
- private_ip_address = "192.168.0.4"

# Crear Grupo de Recursos, Virtual Network y AD DC con valores pesonalizados

```
module "addc" {
  source = "github.com/soysoliscarlos/terraform-azurerm-ADDC.git?ref=0.0.1"
  # Crear Grupo de recursos
  rg_config = {
    create_rg = true
    location  = "eastus2"
    name      = "TEST"
  }
  # Crear Virtual Network
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
  # Crear Máquina virtual
  vm_config = {
    create_vm = false
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

# Output content

To know what is the public IP

```
output "Public-IP" {
  value = "${module.addc.publicip}"
}
```
