# terraform-azurerm-ADDC

[_Click here to see Readme in English_](/README.md)

Módulo de Terraform para crear una máquina virtual en Azure con Controlador de Dominio de Active Directory (AD DC)

NOTA: Por ahora este módulo de terraform solo debe usarse para entornos de desarrollo. NO LO USE PARA ENTORNOS DE PRODUCCIÓN

## Crear grupo de recursos, red virtual y máquina virtual AD DC con valores predeterminados

```terraform
module "addc" {
  source  = "soysoliscarlos/ADDC/azurerm"
  version = "0.0.15"
}
```

### Valores predeterminados

#### Credenciales de la máquina virtual

- username = "azureadmin"
- password = "123456abcDEF."

#### INFORMACIÓN DEL AD DC

- active_directory_domain = "addc.local"
- active_directory_netbios_name = "addc"

#### Grupo de recursos

- name = "RG_addc"
- location = "eastus2"

#### Red virtual

- name = "VNet_01"
- dns_servers = ["192.168.0.4"]
- address_space = ["192.168.0.0/24"]

##### Subred

- name = "default"
- address_prefixes = ["192.168.0.0/24"]

##### Grupo de seguridad de red

- name = "NSG_addc"

#### Máquina virtual

- name = "VM_01"
- subnet = "default"
- private_ip_address = "192.168.0.4"

## Uso de Grupo de recursos

### Crear grupo de recursos personalizado

```terraform
module "addc" {
  source  = "soysoliscarlos/ADDC/azurerm"
  version = "0.0.15"
  # Create CustomResource Group
  use_custom_rg = true
  rg_name = "addc" # El nombre final será el prefijo + Nombre de la varible ; ej "RG_addc"
  rg_location = "eastus2"
}
```

### Usar fuente de datos de un grupo de recursos

```terraform
data "azurerm_resource_group" "default" {
  name = "RG_addc"
}

module "addc" {
  source  = "soysoliscarlos/ADDC/azurerm"
  version = "0.0.15"
  # Create CustomResource Group
  use_custom_rg = true
  rg_data = data.azurerm_resource_group.rg
}
```

## Crear grupo de recursos, red virtual y máquina virtual AD DC con valores personalizados

```terraform
module "addc" {
    source  = "soysoliscarlos/ADDC/azurerm"
  version = "0.0.15"
  # Crear grupo de recursos personalizado
  use_custom_rg = true
  rg_name = "addc" # El nombre final será el prefijo + Nombre de la varible ; ej "RG_addc"
  rg_location = "eastus2"
  # Crear red virtual
  vnet_config =
  {
      create_vnet = true
      name = "TEST"
      dns_servers = ["192.168.0.4"]
      address_space = ["192.168.0.0/24"]
    }
  # Crear Subred
  subnets_config = [
     {
        name = "default"
        address_prefixes = ["192.168.0.0/24"]
    } 
  ]
  # Grupo de seguridad de red
  nsg_name = "addc"

  # Crear máquina virtual
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

## Prefijo predeterminado

Por defecto, todos los recursos tienen los siguientes prefijos:

| Recurso      |  Prefijo  |
|----------------|--------:|
| Resource group | RG_    |
| Virtual Network | VNet_ |
| Network Security Group| NSG_ |
| Public IP | PIP_ |
| Network Interface | NIC_ |
|Virtual Machine | VM_ |

Si no quieres usar los prefijos predeterminados, puedes usar la siguiente variable en el módulo

```terraform
use_custom_resource_prefix_name = true
```

## Contenido de salida

Para saber cuál es la IP pública de la máquina virtual, añade el siguiente bloque:

```terraform
output "Public-IP" {
  value = "${module.addc.publicip}"
}
```
