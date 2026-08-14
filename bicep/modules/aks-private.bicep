param name string
param location string
param rgName string
param dnsPrefix string
param kubernetesVersion string

param privateDnsZoneId string
param nodepoolSubnetId string
param identityId string
param logAnalyticsId string

resource aks 'Microsoft.ContainerService/managedClusters@2023-05-01' = {
  name: name
  location: location
  properties: {
    dnsPrefix: dnsPrefix
    kubernetesVersion: kubernetesVersion

    apiServerAccessProfile: {
      enablePrivateCluster: true
      privateDNSZone: privateDnsZoneId
    }

    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'calico'
      outboundType: 'userDefinedRouting'
      loadBalancerSku: 'standard'
      serviceCidr: '10.0.0.0/16'
      dnsServiceIP: '10.0.0.10'
      dockerBridgeCidr: '172.17.0.1/16'
    }

    agentPoolProfiles: [
      {
        name: 'system'
        vmSize: 'Standard_DS2_v2'
        count: 1
        mode: 'System'
        vnetSubnetID: nodepoolSubnetId
      }
    ]

    identity: {
      type: 'UserAssigned'
      userAssignedIdentities: {
        '${identityId}': {}
      }
    }

    aadProfile: {
      managed: true
      enableAzureRBAC: true
    }

    addonProfiles: {
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logAnalyticsId
        }
      }
    }
  }
}

output aksId string = aks.id
output aksFqdn string = aks.properties.fqdn