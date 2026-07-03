resource "azurerm_resource_group" "lab_aks" {
  name     = var.name
  location = var.location
  tags     = var.tags
}