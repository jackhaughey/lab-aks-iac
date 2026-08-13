variable "acr_name" {
  type        = string
  description = "Name of the Azure Container Registry"
}

variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "acr_sku" {
  type        = string
  description = "ACR SKU (e.g. Basic, Standard, Premium)"
  default     = "Standard"
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
  description = "Tags to apply to resources"
  default     = {}
}

ter
