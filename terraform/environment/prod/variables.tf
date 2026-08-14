variable "prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "acr_sku" {
  type    = string
  default = "Standard"
}

variable "kv_sku" {
  type    = string
  default = "standard"
}

variable "hub_address_space" {
  type = string
}

variable "spoke_address_space" {
  type = string
}

variable "firewall_subnet_prefix" {
  type = string
}

variable "bastion_subnet_prefix" {
  type = string
}

variable "aks_subnet_prefix" {
  type = string
}

variable "private_endpoints_prefix" {
  type = string
}

variable "firewall_private_ip" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
