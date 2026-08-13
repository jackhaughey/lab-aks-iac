variable "name" {
  type        = string
  description = "AKS cluster name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "dns_prefix" {
  type        = string
  description = "DNS prefix for AKS"
}

variable "kubernetes_version" {
  type        = string
  description = "AKS Kubernetes version"
}

variable "private_dns_zone_id" {
  type        = string
  description = "Private DNS zone ID for AKS API"
}

variable "nodepool_subnet_id" {
  type        = string
  description = "Subnet ID for AKS node pool"
}

variable "aks_identity_id" {
  type        = string
  description = "User-assigned managed identity ID"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics workspace ID"
}

variable "system_node_vm_size" {
  type        = string
  default     = "Standard_DS2_v2"
}

variable "system_node_count" {
  type        = number
  default     = 1
}

variable "dns_service_ip" {
  type        = string
  default     = "10.0.0.10"
}

variable "service_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "docker_bridge_cidr" {
  type        = string
  default     = "172.17.0.1/16"
}

variable "tags" {
  type        = map(string)
  default     = {}
}
