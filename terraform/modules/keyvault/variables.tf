variable "kv_name" {
  type        = string
  description = "Key Vault name"
}

variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID"
}

variable "kv_sku" {
  type        = string
  description = "Key Vault SKU (standard or premium)"
  default     = "standard"
}

variable "spoke_vnet_id" {
  type        = string
  description = "Spoke VNet ID for DNS link"
}

variable "private_endpoints_subnet_id" {
  type        = string
  description = "Subnet ID for private endpoints"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to resources"
}
