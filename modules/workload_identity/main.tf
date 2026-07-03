resource "azurerm_user_assigned_identity" "workload" {
  name                = "uai-aks-workload"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_federated_identity_credential" "github" {
  name                = "fic-github-aks"
  resource_group_name = var.resource_group_name
  issuer              = var.github_oidc_issuer
  subject             = var.github_oidc_subject
  audience            = ["api://AzureADTokenExchange"]
  parent_id           = azurerm_user_assigned_identity.workload.id
}