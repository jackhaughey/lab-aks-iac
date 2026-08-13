resource "azurerm_key_vault" "kv" {
  name                        = var.kv_name
  location                    = var.location
  resource_group_name         = var.rg_name
  tenant_id                   = var.tenant_id
  sku_name                    = var.kv_sku
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.tags
}

# -------------------------
# Private DNS zone for Key Vault
# -------------------------
resource "azurerm_private_dns_zone" "kv" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv_spoke_link" {
  name                  = "kv-spoke-link"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.kv.name
  virtual_network_id    = var.spoke_vnet_id
  registration_enabled  = false
}

# -------------------------
# Private Endpoint
# -------------------------
resource "azurerm_private_endpoint" "kv_pe" {
  name                = "${var.kv_name}-pe"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.private_endpoints_subnet_id

  private_service_connection {
    name                           = "${var.kv_name}-pe-conn"
    private_connection_resource_id = azurerm_key_vault.kv.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  tags = var.tags
}

# -------------------------
# DNS A Record
# -------------------------
resource "azurerm_private_dns_a_record" "kv_record" {
  name                = azurerm_key_vault.kv.name
  zone_name           = azurerm_private_dns_zone.kv.name
  resource_group_name = var.rg_name
  ttl                 = 300
  records             = [
    azurerm_private_endpoint.kv_pe.private_service_connection[0].private_ip_address
  ]
}
