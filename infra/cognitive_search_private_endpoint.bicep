// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

param privateEndpointName string
param location string
param virtualNetworkId string
param pepSubnetName string
param vnetName string
param cognitiveSearchService string

resource cognitive_search_service 'Microsoft.Search/searchServices@2022-09-01' existing = {
  name: cognitiveSearchService
}

resource dnsZones 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.search.windows.net'
  location: 'global'
  tags: {}
  properties: {}
  resource virtualNetworkLink 'virtualNetworkLinks' = {
    name: virtualNetworkId
    location: 'global'
    properties: {
      virtualNetwork: {
        id: vnet.id
      }
      registrationEnabled: false
    }
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: vnetName
  resource privateLinkSubnet 'subnets' existing = {
    name: pepSubnetName
  }
}

resource cogSearchPrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-04-01' = {
  location: location
  name: privateEndpointName
  properties: {
    subnet: {
      id: vnet::privateLinkSubnet.id
    }
    customNetworkInterfaceName: 'pe-nic-cogsearch'
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: cognitive_search_service.id
          groupIds: ['searchService']
        }
      }
    ]
  }
  tags: {}
  dependsOn: [dnsZones]

  resource dnsZoneGroup 'privateDnsZoneGroups' = {
    name: '${privateEndpointName}-default'
    properties: {
      privateDnsZoneConfigs: [
        {
          name: 'privatelink-search-windows-net'
          properties: {
            privateDnsZoneId: dnsZones.id
          }
        }
      ]
    }
  }
}
