variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "github_oidc_issuer" {
  type = string
}

variable "github_oidc_subject" {
  type = string
}

variable "tags" {
  type = map(string)
}