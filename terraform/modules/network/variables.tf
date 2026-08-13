variable "prefix" {
  type        = string
  description = "Prefix for all network resources"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "rg_name" {
  type        = string
  description = "Resource group name for networking"
}

variable "hub_address_space" {
  type        = string
  description = "Hub VNet address space"
}

variable "spoke_address_space" {
  type        = string
  description = "Spoke VNet address space"
}

variable "firewall_subnet_prefix" {
  type        = string
  description = "AzureFirewallSubnet prefix"
}

variable "bastion_subnet_prefix" {
  type        = string
  description = "AzureBastionSubnet prefix"
}

variable "aks_subnet_prefix" {
  type        = string
  description = "AKS nodepool subnet prefix"
}

variable "private_endpoints_prefix" {
  type        = string
  description = "Private endpoints subnet prefix"
}

variable "firewall_private_ip" {
  type        = string
  description = "Azure Firewall private IP for UDR routing"
}
