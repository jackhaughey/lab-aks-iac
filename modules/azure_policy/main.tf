resource "azurerm_policy_assignment" "aks_private_cluster" {
  name                 = "enforce-aks-private-cluster"
  scope                = var.aks_id
  policy_definition_id = var.policy_definition_id_private_cluster
}

resource "azurerm_policy_assignment" "aks_https_ingress" {
  name                 = "enforce-https-ingress"
  scope                = var.aks_id
  policy_definition_id = var.policy_definition_id_https_ingress
}