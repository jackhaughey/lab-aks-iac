@description('Prefix for all resources')
param prefix string = 'prod'

@description('Azure region')
param location string = 'uksouth'

@description('Tenant ID for Key Vault')
param tenantId string

@description('AKS Kubernetes version')
param kubernetesVersion string = '1.29.2'

@description('ACR SKU')
param acrSku string = 'Premium'

@description('Key Vault SKU')
param kvSku string = 'premium'

@description('Hub VNet address space')
param hubAddressSpace string = '10.10.0.0/16'

@description('Spoke VNet address space')
param spokeAddressSpace string = '10.11.0.0/16'

@description('Firewall subnet prefix')
param firewallSubnetPrefix string = '10.10.1.0/24'

@description('Bastion subnet prefix')
param bastionSubnetPrefix string = '10.10.2.0/24'

@description('AKS subnet prefix')
param aksSubnetPrefix string = '10.11.1.0/24'

@description('Private endpoints subnet prefix')
param privateEndpointsPrefix string = '10.11.2.0/24'

@description('Firewall private IP for UDR')
param firewallPrivateIp string = '10.10.1.4'

@description('Tags')
param tags object = {
  environment: 'prod'
  owner: 'jack'
}

//
// Resource Group
//
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${prefix}-rg'
  location: location
}

//
// Network Module
//
module network '../../modules/network.bicep' = {
  name: '${prefix}-network'
  scope: rg
  params: {
    prefix: prefix
    location: location
    rgName: rg.name
    hubAddressSpace: hubAddressSpace
    spokeAddressSpace: spokeAddressSpace
    firewallSubnetPrefix: firewallSubnetPrefix
    bastionSubnetPrefix: bastionSubnetPrefix
    aksSubnetPrefix: aksSubnetPrefix
    privateEndpointsPrefix: privateEndpointsPrefix
    firewallPrivateIp: firewallPrivateIp
  }
}

//
// User Assigned Identity for AKS
//
resource aksIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: '${prefix}-aks-mi'
  location: location
}

//
// Log Analytics Workspace
//
resource law 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: '${prefix}-law'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

//
// AKS Module
//
module aks '../../modules/aks-private.bicep' = {
  name: '${prefix}-aks'
  scope: rg
  params: {
    name: '${prefix}-aks'
    location: location
    rgName: rg.name
    dnsPrefix: '${prefix}-dns'
    kubernetesVersion: kubernetesVersion
    privateDnsZoneId: network.outputs.privateDnsZoneId
    nodepoolSubnetId: network.outputs.aksSubnetId
    identityId: aksIdentity.id
    logAnalyticsId: law.id
  }
}

//
// ACR Module
//
module acr '../../modules/acr-private.bicep' = {
  name: '${prefix}-acr'
  scope: rg
  params: {
    acrName: '${prefix}acr'
    location: location
    rgName: rg.name
    sku: acrSku
    spokeVnetId: network.outputs.spokeVnetId
    privateEndpointsSubnetId: network.outputs.privateEndpointsSubnetId
  }
}

//
// Key Vault Module
//
module keyvault '../../modules/keyvault-private.bicep' = {
  name: '${prefix}-kv'
  scope: rg
  params: {
    kvName: '${prefix}-kv'
    location: location
    rgName: rg.name
    tenantId: tenantId
    sku: kvSku
    spokeVnetId: network.outputs.spokeVnetId
    privateEndpointsSubnetId: network.outputs.privateEndpointsSubnetId
  }
}

//
// Bastion Module
//
module bastion '../../modules/bastion.bicep' = {
  name: '${prefix}-bastion'
  scope: rg
  params: {
    prefix: prefix
    location: location
    rgName: rg.name
    bastionSubnetId: network.outputs.bastionSubnetId
  }
}

output aksFqdn string = aks.outputs.aksFqdn
output acrLoginServer string = acr.outputs.acrLoginServer
output keyVaultUri string = keyvault.outputs.kvUri
output bastionIp string = bastion.outputs.bastionIp