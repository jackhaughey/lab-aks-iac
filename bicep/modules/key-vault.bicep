param kvName string
param location string
param rgName string
param tenantId string
param sku string
param spokeVnetId string
param privateEndpointsSubnetId string

resource kv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: kvName
  location: location
  properties: {
    tenantId: tenantId
    sku: {
      name: sku
      family: 'A'
    }
    enableRbacAuthorization: true
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
  }
}

resource dnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.vaultcore.azure.net'
}

resource dnsLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'kv-spoke-link'
  parent: dnsZone
  properties: {
    virtualNetwork: {
      id: spokeVnetId
    }
    registrationEnabled: false
  }
}

resource pe 'Microsoft.Network/privateEndpoints@2023-05-01' = {
  name: '${kvName}-pe'
  location: location
  properties: {
    subnet: {
      id: privateEndpointsSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: '${kvName}-conn'
        properties: {
          privateLinkServiceId: kv.id
          subresourceNames: ['vault']
        }
      }
    ]
  }
}

resource dnsRecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: kvName
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

output kvUri string = kv.properties.vaultUri