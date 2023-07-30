

variable "admin_username" {
  default = "azureadmin"
}

variable "admin_password" {
  default = "123456abcDEF."
}

variable "active_directory_domain" {
  default = "addc.local"
}

variable "active_directory_netbios_name" {
  default = "addc"
}

#RG
## Crear RG
variable "use_custom_rg" {
  type = bool
  default = false
}
variable "rg_name" {
  type =  string
  default = "addc"
}
variable "location" {
  type =  string
  default = "eastus2"
}
variable "rg_data" {
  default = null
}

#VNET
variable "vnet_config" {
  type = object({
    create_vnet   = bool
    name          = string
    dns_servers   = list(string)
    address_space = list(string)
  })
  default = {
    create_vnet   = true
    name          = "01"
    dns_servers   = ["192.168.0.4"]
    address_space = ["192.168.0.0/24"]
  }
}

variable "subnets_config" {
  type = list(object({
    name             = string
    address_prefixes = list(string)
  }))
  default = [{
    name             = "default"
    address_prefixes = ["192.168.0.0/24"]
  }]
}

# Máquina virtual
variable "vm_config" {
  type = object({
    create_vm          = bool
    name               = string
    subnet             = string
    private_ip_address = string
  })
  default = {
    create_vm          = true
    name               = "01"
    subnet             = "default"
    private_ip_address = "192.168.0.4"
  }
}

variable "virtual_machine_name" {
  type        = string
  description = "vm name"
  default     = "01"
}