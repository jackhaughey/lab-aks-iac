terraform {
  backend "azurerm" {
    resource_group_name  = "<YOUR_BACKEND_RG>"
    storage_account_name = "<YOUR_BACKEND_STORAGE>"
    container_name       = "tfstate"
    key                  = "private-aks-dev.tfstate"
  }
}

