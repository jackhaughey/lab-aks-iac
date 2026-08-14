param prefix string
param location string
param rgName string

param hubAddressSpace string
param spokeAddressSpace string

param firewallSubnetPrefix string
param bastionSubnetPrefix string
param aksSubnetPrefix string
param privateEndpointsPrefix string

param firewallPrivateIp string

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: rgName
}

resource hubVnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: '${prefix}-hub-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [hubAddressSpace]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: firewallSubnetPrefix
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: bastionSubnetPrefix
        }
      }
    ]
  }
}

resource spokeVnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: '${prefix}-spoke-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [spokeAddressSpace]
    }
    subnets: [
      {
        name: 'aks-nodepool'
        properties: {
          addressPrefix: aksSubnetPrefix
        }
      }
      {
        name: 'private-endpoints'
        properties: {
          addressPrefix: privateEndpointsPrefix
        }
      }
    ]
  }
}

resource hubToSpoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'hub-to-spoke'
  parent: hubVnet
  properties: {
    remoteVirtualNetwork: {
      id: spokeVnet.id
    }
    allowForwardedTraffic: true
  }
}

resource spokeToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'spoke-to-hub'
  parent: spokeVnet
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
    allowForwardedTraffic: true
  }
}

resource aksRouteTable 'Microsoft.Network/routeTables@2023-05-01' = {
  name: '${prefix}-aks-udr'
  location: location
}

resource aksRoute 'Microsoft.Network/routeTables/routes@2023-05-01' = {
  name: 'default-to-firewall'
  parent: aksRouteTable
  properties: {
    addressPrefix: '0.0.0.0/0'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: firewallPrivateIp
  }
}

resource aksSubnetAssoc 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' existing = {
  name: 'aks-nodepool'
  parent: spokeVnet
}

resource aksSubnetRouteAssoc 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' = {
  name: 'aks-nodepool'
  parent: spokeVnet
  properties: {
    routeTable: {
      id: aksRouteTable.id
    }
  }
}

resource aksDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.${location}.azmk8s.io'
  location: 'global'
}

resource dnsLinkSpoke 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'spoke-link'
  parent: aksDnsZone
  properties: {
    virtualNetwork: {
      id: spokeVnet.id
    }
    registrationEnabled: false
  }
}

output aksSubnetId string = aksSubnetAssoc.id
output privateEndpointsSubnetId string = spokeVnet.properties.subnets[1].id
output privateDnsZoneId string = aksDnsZone.id
output spokeVnetId string = spokeVnet.id
output bastionSubnetId string = hubVnet.properties.subnets[1].id