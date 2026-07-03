terraform {
  required_version = ">= 1.6.0"

  backend "azurerm" {
    resource_group_name  = "rg-tfstate-aks-lab"
    storage_account_name = "sttfstateakslab"
    container_name       = "tfstate"
  }
}

provider "azurerm" {
  features {}
}

locals {
  tags = {
    project     = "aks-lab"
    environment = var.env
    zero_trust  = "true"
  }
}

data "azurerm_client_config" "current" {}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# -----------------------------
# Resource Group
# -----------------------------
module "rg" {
  source   = "../../modules/resource_group"
  name     = "rg-${var.env}-aks"
  location = var.location
  tags     = local.tags
}

# -----------------------------
# Network (with segmentation)
# -----------------------------
module "network" {
  source              = "../../modules/network"
  env                 = var.env
  location            = module.rg.location
  resource_group_name = module.rg.name

  address_space     = "10.30.0.0/16"
  aks_subnet_prefix = "10.30.1.0/24"

  tags = local.tags
}

# -----------------------------
# Network Security (NSGs + UDRs)
# -----------------------------
module "network_security" {
  source              = "../../modules/network_security"
  resource_group_name = module.rg.name
  aks_subnet_id       = module.network.aks_subnet_id
  tags                = local.tags
}

# -----------------------------
# ACR (private)
# -----------------------------
module "acr" {
  source              = "../../modules/acr"
  env                 = var.env
  random_suffix       = random_string.suffix.result
  location            = module.rg.location
  resource_group_name = module.rg.name
  sku                 = "Premium"
  tags                = local.tags
}

# Private Endpoint for ACR
module "acr_private_endpoint" {
  source              = "../../modules/private_endpoints"
  resource_group_name = module.rg.name
  location            = module.rg.location
  target_resource_id  = module.acr.id
  subnet_id           = module.network.private_endpoint_subnet_id
  private_dns_zone_id = module.private_dns.acr_zone_id
}

# Key Vault (private)

module "keyvault" {
  source              = "../../modules/keyvault"
  env                 = var.env
  random_suffix       = random_string.suffix.result
  location            = module.rg.location
  resource_group_name = module.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = local.tags
}

module "keyvault_private_endpoint" {
  source              = "../../modules/private_endpoints"
  resource_group_name = module.rg.name
  location            = module.rg.location
  target_resource_id  = module.keyvault.id
  subnet_id           = module.network.private_endpoint_subnet_id
  private_dns_zone_id = module.private_dns.keyvault_zone_id
}

# Private DNS Zones

module "private_dns" {
  source              = "../../modules/private_dns"
  resource_group_name = module.rg.name
  location            = module.rg.location
  vnet_id             = module.network.vnet_id
}

# Workload Identity

module "workload_identity" {
  source              = "../../modules/workload_identity"
  resource_group_name = module.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = local.tags
}

# AKS (private cluster)

module "aks" {
  source              = "../../modules/aks"
  env                 = var.env
  location            = module.rg.location
  resource_group_name = module.rg.name
  aks_subnet_id       = module.network.aks_subnet_id

  kubernetes_version = "1.29.4"

  system_vm_size    = "Standard_D4s_v5"
  system_node_count = 3

  private_cluster_enabled = true
  network_policy          = "azure"

  tags = local.tags
}

# Azure Policy

module "azure_policy" {
  source              = "../../modules/azure_policy"
  resource_group_name = module.rg.name
  aks_id              = module.aks.id
}

output "kube_config" {
  value     = module.aks.kube_config
  sensitive = true
}