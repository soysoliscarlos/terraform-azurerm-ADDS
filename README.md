# terraform-azurerm-ADDC

Modulo para crear una VM con AD DC

# Crear Grupo de Recursos, Virtual Network y AD DC con valores por defecto

```
module "addc" {
  source = "github.com/soysoliscarlos/terraform-azurerm-ADDC.git?ref=0.0.1"
}
```

# Crear -Grupo de Recursos, Virtual Network y AD DC con valores pesonalizados

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
      dns_servers = []
      address_space = ["192.168.0.0/24"]
    }
  # Crear Subnet
  subnets_config = [
     {
        name = "default"
        address_prefixes = ["192.168.0.0/24"]
    } 
  ]

}
```