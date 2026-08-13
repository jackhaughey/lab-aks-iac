output "acr_id" {
  value       = azurerm_container_registry.acr.id
  description = "ACR resource ID"
}

output "acr_login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "ACR login server"
}

output "acr_private_endpoint_id" {
  value       = azurerm_private_endpoint.acr_pe.id
  description = "ACR private endpoint ID"
}

output "acr_private_dns_zone_id" {
  value       = azurerm_private_dns_zone.acr.id
  description = "ACR private DNS zone ID"
}


