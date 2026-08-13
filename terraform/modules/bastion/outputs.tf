output "bastion_id" {
  value       = azurerm_bastion_host.bastion.id
  description = "Azure Bastion resource ID"
}

output "bastion_public_ip" {
  value       = azurerm_public_ip.bastion.ip_address
  description = "Azure Bastion public IP address"
}
