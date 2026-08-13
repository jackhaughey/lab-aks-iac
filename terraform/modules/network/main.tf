# -------------------------
# Resource Group (optional)
# -------------------------
resource "azurerm_resource_group" "network" {
  name     = var.rg_name
  location = var.location
}

# -------------------------
# Hub VNet
# -------------------------
resource "azurerm_virtual_network" "hub" {
  name                = "${var.prefix}-hub-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = [var.hub_address_space]
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.firewall_subnet_prefix]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.bastion_subnet_prefix]
}

# -------------------------
# Spoke VNet
# -------------------------
resource "azurerm_virtual_network" "spoke" {
  name                = "${var.prefix}-spoke-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = [var.spoke_address_space]
}

resource "azurerm_subnet" "aks" {
  name                 = "aks-nodepool"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.aks_subnet_prefix]
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "private-endpoints"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.private_endpoints_prefix]
}

# -------------------------
# VNet Peering
# -------------------------
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "hub-to-spoke"
  resource_group_name       = azurerm_resource_group.network.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "spoke-to-hub"
  resource_group_name       = azurerm_resource_group.network.name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  allow_forwarded_traffic   = true
  use_remote_gateways       = false
}

# -------------------------
# UDR for AKS outbound → Firewall
# -------------------------
resource "azurerm_route_table" "aks_udr" {
  name                = "${var.prefix}-aks-udr"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_route" "aks_default_route" {
  name                   = "default-to-firewall"
  resource_group_name    = azurerm_resource_group.network.name
  route_table_name       = azurerm_route_table.aks_udr.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip
}

resource "azurerm_subnet_route_table_association" "aks_udr_assoc" {
  subnet_id      = azurerm_subnet.aks.id
  route_table_id = azurerm_route_table.aks_udr.id
}

# -------------------------
# Private DNS Zone for AKS API
# -------------------------
resource "azurerm_private_dns_zone" "aks" {
  name                = "privatelink.${var.location}.azmk8s.io"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks_spoke_link" {
  name                  = "aks-spoke-link"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
  registration_enabled  = false
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks_hub_link" {
  name                  = "aks-hub-link"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = azurerm_virtual_network.hub.id
  registration_enabled  = false
}
