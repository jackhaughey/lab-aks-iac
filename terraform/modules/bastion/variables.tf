variable "prefix" {
  type        = string
  description = "Prefix for Bastion resources"
}

variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "bastion_subnet_id" {
  type        = string
  description = "Subnet ID for Azure Bastion (AzureBastionSubnet)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to resources"
}
