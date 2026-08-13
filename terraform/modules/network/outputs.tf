output "hub_vnet_id" {
  value       = azurerm_virtual_network.hub.id
  description = "Hub VNet ID"
}

output "spoke_vnet_id" {
  value       = azurerm_virtual_network.spoke.id
  description = "Spoke VNet ID"
}

output "aks_subnet_id" {
  value       = azurerm_subnet.aks.id
  description = "AKS nodepool subnet ID"
}

output "private_endpoints_subnet_id" {
  value       = azurerm_subnet.private_endpoints.id
  description = "Private endpoints subnet ID"
}

output "private_dns_zone_id" {
  value       = azurerm_private_dns_zone.aks.id
  description = "AKS private DNS zone ID"
}

