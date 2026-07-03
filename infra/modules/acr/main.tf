resource "azurerm_container_registry" "lab_aks" {
  name                = "${var.env}acr${var.random_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  admin_enabled       = false
  tags                = var.tags
}