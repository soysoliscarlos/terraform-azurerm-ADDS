variable "Project" {
  type    = string
  default = "ADDC"
}

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