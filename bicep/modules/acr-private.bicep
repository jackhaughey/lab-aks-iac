aram acrName string
param location string
param rgName string
param sku string
param spokeVnetId string
param privateEndpointsSubnetId string

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: false
  }
}

resource dnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.azurecr.io'
}

resource dnsLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'acr-spoke-link'
  parent: dnsZone
  properties: {
    virtualNetwork: {
      id: spokeVnetId
    }
    registrationEnabled: false
  }
}

resource pe 'Microsoft.Network/privateEndpoints@2023-05-01' = {
  name: '${acrName}-pe'
  location: location
  properties: {
    subnet: {
      id: privateEndpointsSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: '${acrName}-conn'
        properties: {
          privateLinkServiceId: acr.id
          subresourceNames: ['registry']
        }
      }
    ]
  }
}

resource dnsRecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: acrName
  parent: dnsZone
  properties: {
    ttl: 300
    aRecords: [
      {
        ipv4Address: pe.properties.networkInterfaces[0].properties.ipConfigurations[0].properties.privateIPAddress
      }
    ]
  }
}

output acrId string = acr.id
output acrLoginServer string = acr.properties.loginServer