output "kube_config" {
  value     = azurerm_kubernetes_cluster.lab_aks.kube_config_raw
  sensitive = true
}