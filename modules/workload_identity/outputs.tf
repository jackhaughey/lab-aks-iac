output "identity_id" {
  value = azurerm_user_assigned_identity.workload.id
}

output "identity_client_id" {
  value = azurerm_user_assigned_identity.workload.client_id
}