resource "azurerm_key_vault" "lab_aks" {
  name                        = "${var.env}-kv-${var.random_suffix}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  soft_delete_enabled         = true
  purge_protection_enabled    = false
  enabled_for_disk_encryption = true
  tags                        = var.tags
}
