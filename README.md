


## Components

### Hub VNet

      -  Azure Firewall or NVA

      -  Bastion / Jumpbox

      -  Shared services (Log Analytics, Key Vault)

### Spoke VNet

      -  Private AKS cluster

      -  Node pool subnets

      -  Private endpoints (AKS API, ACR, Key Vault)

### Private DNS Zone

      -  privatelink.<region>.azmk8s.io

Private AKS requires:

  -  No public API exposure

  -  Private Link endpoint for control plane

  -  DNS resolution inside the VNet

  -  UDR for outbound traffic (Azure Firewall recommended)
