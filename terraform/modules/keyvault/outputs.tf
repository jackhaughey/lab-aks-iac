output "key_vault_id" {
  value       = azurerm_key_vault.kv.id
  description = "Key Vault resource ID"
}

output "key_vault_uri" {
  value       = azurerm_key_vault.kv.vault_uri
  description = "Key Vault URI"
}

output "key_vault_private_endpoint_id" {
  value       = azurerm_private_endpoint.kv_pe.id
  description = "Key Vault private endpoint ID"
}

output "key_vault_private_dns_zone_id" {
  value       = azurerm_private_dns_zone.kv.id
  description = "Key Vault private DNS zone ID"
}

