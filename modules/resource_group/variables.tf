variable "name" {
  type    = string
  default = dev
}

variable "location" {
  type    = string
  default = "dev"
}

variable "tags" {
  type        = map(string)
  Environment = "dev"
  Lab         = "lab_aks"
}