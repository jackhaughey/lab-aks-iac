variable "env" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "aks_subnet_id" {
  type = string
}

variable "kubernetes_version" {
  type    = string
  default = "1.29.4"
}

variable "system_vm_size" {
  type    = string
  default = "Standard_D2s_v5"
}

variable "system_node_count" {
  type    = number
  default = 2
}

variable "tags" { type = map(string) }