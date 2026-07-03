output "acr_zone_id" {
  value = azurerm_private_dns_zone.acr.id
}

output "keyvault_zone_id" {
  value = azurerm_private_dns_zone.keyvault.id
}

output "aks_zone_id" {
  value = azurerm_private_dns_zone.aks.id
}
