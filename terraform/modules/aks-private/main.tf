resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name

  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  private_cluster_enabled = true
  private_dns_zone_id     = var.private_dns_zone_id

  api_server_access_profile {
    enable_private_cluster = true
  }

  network_profile {
    network_plugin      = "azure"
    network_policy      = "calico"
    outbound_type       = "userDefinedRouting"
    load_balancer_sku   = "standard"
    dns_service_ip      = var.dns_service_ip
    service_cidr        = var.service_cidr
    docker_bridge_cidr  = var.docker_bridge_cidr
  }

  default_node_pool {
    name                 = "system"
    vm_size              = var.system_node_vm_size
    node_count           = var.system_node_count
    vnet_subnet_id       = var.nodepool_subnet_id
    type                 = "VirtualMachineScaleSets"
    orchestrator_version = var.kubernetes_version
    enable_auto_scaling  = false
    mode                 = "System"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.aks_identity_id]
  }

  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  role_based_access_control_enabled = true

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  tags = var.tags
}
