###############################
# Resource Group
###############################
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}

###############################
# Network Module
###############################
module "network" {
  source = "../../modules/network"

  prefix                       = var.prefix
  rg_name                      = azurerm_resource_group.rg.name
  location                     = var.location
  hub_address_space            = var.hub_address_space
  spoke_address_space          = var.spoke_address_space
  firewall_subnet_prefix       = var.firewall_subnet_prefix
  bastion_subnet_prefix        = var.bastion_subnet_prefix
  aks_subnet_prefix            = var.aks_subnet_prefix
  private_endpoints_prefix     = var.private_endpoints_prefix
  firewall_private_ip          = var.firewall_private_ip

  tags = var.tags
}

###############################
# User Assigned Identity for AKS
###############################
resource "azurerm_user_assigned_identity" "aks" {
  name                = "${var.prefix}-aks-mi"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

###############################
# Log Analytics Workspace
###############################
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-law"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

###############################
# AKS Module
###############################
module "aks" {
  source = "../../modules/aks-private"

  name                        = "${var.prefix}-aks"
  location                    = var.location
  rg_name                     = azurerm_resource_group.rg.name
  dns_prefix                  = "${var.prefix}-dns"
  kubernetes_version          = var.kubernetes_version
  private_dns_zone_id         = module.network.private_dns_zone_id
  nodepool_subnet_id          = module.network.aks_subnet_id
  aks_identity_id             = azurerm_user_assigned_identity.aks.id
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.law.id

  tags = var.tags
}

###############################
# ACR Module
###############################
module "acr" {
  source = "../../modules/acr-private"

  acr_name                    = "${var.prefix}acr"
  rg_name                     = azurerm_resource_group.rg.name
  location                    = var.location
  acr_sku                     = var.acr_sku
  spoke_vnet_id               = module.network.spoke_vnet_id
  private_endpoints_subnet_id = module.network.private_endpoints_subnet_id

  tags = var.tags
}

###############################
# Key Vault Module
###############################
module "keyvault" {
  source = "../../modules/keyvault-private"

  kv_name                     = "${var.prefix}-kv"
  rg_name                     = azurerm_resource_group.rg.name
  location                    = var.location
  tenant_id                   = var.tenant_id
  kv_sku                      = var.kv_sku
  spoke_vnet_id               = module.network.spoke_vnet_id
  private_endpoints_subnet_id = module.network.private_endpoints_subnet_id

  tags = var.tags
}

###############################
# Bastion Module
###############################
module "bastion" {
  source = "../../modules/bastion"

  prefix            = var.prefix
  rg_name           = azurerm_resource_group.rg.name
  location          = var.location
  bastion_subnet_id = module.network.bastion_subnet_id

  tags = var.tags
}
