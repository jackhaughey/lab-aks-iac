resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = false

  tags = var.tags
}

# Private DNS zone for ACR (privatelink.azurecr.io)
resource "azurerm_private_dns_zone" "acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr_spoke_link" {
  name                  = "acr-spoke-link"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = var.spoke_vnet_id
  registration_enabled  = false
}

# Private endpoint for ACR
resource "azurerm_private_endpoint" "acr_pe" {
  name                = "${var.acr_name}-pe"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.private_endpoints_subnet_id

  private_service_connection {
    name                           = "${var.acr_name}-pe-conn"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  tags = var.tags
}

# DNS A record for ACR private endpoint
resource "azurerm_private_dns_a_record" "acr_pe_record" {
  name                = azurerm_container_registry.acr.name
  zone_name           = azurerm_private_dns_zone.acr.name
  resource_group_name = var.rg_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.acr_pe.private_service_connection[0].private_ip_address]
}
