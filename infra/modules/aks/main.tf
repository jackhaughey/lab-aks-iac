resource "azurerm_kubernetes_cluster" "lab_aks" {
  name                = "${var.env}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.env}-dns"

  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name           = "system"
    vm_size        = var.system_vm_size
    node_count     = var.system_node_count
    vnet_subnet_id = var.aks_subnet_id
    type           = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  role_based_access_control_enabled = true
  tags                              = var.tags
}