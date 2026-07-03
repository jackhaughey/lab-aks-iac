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
  }
}

data "azurerm_client_config" "current" {}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

module "rg" {
  source  = "../../modules/resource_group"
  name    = "rg-${var.env}-aks"
  location = var.location
  tags     = local.tags
}

module "network" {
  source              = "../../modules/network"
  env                 = var.env
  location            = module.rg.location
  resource_group_name = module.rg.name
  address_space       = "10.10.0.0/16"
  aks_subnet_prefix   = "10.10.1.0/24"
  tags                = local.tags
}

module "acr" {
  source              = "../../modules/acr"
  env                 = var.env
  random_suffix       = random_string.suffix.result
  location            = module.rg.location
  resource_group_name = module.rg.name
  sku                 = "Basic"
  tags                = local.tags
}

module "keyvault" {
  source              = "../../modules/keyvault"
  env                 = var.env
  random_suffix       = random_string.suffix.result
  location            = module.rg.location
  resource_group_name = module.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = local.tags
}

module "aks" {
  source              = "../../modules/aks"
  env                 = var.env
  location            = module.rg.location
  resource_group_name = module.rg.name
  aks_subnet_id       = module.network.aks_subnet_id

  system_vm_size    = "Standard_D2s_v5"
  system_node_count = 2

  tags = local.tags
}

output "kube_config" {
  value     = module.aks.kube_config
  sensitive = true
}