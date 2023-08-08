param privateEndpointName string
param location string
param virtualNetworkId string
param pepSubnetName string
param vnetName string
param cognitiveSearchService string

resource cognitive_search_service 'Microsoft.Search/searchServices@2020-08-01' existing = {
  name: cognitiveSearchService
}

resource privatelink_search_windows_net 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: 'privatelink.search.windows.net'
  location: 'global'
  tags: {}
  properties: {}
  resource privatelink_search_windows_net_virtualNetworkId 'virtualNetworkLinks' = {
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

resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
  name: vnetName
  resource privateLinkSubnet 'subnets' existing = {
    name: pepSubnetName
  }
}


resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  location: location
  name: privateEndpointName
  properties: {
    subnet: {
      id: vnet::privateLinkSubnet.id
    }
    customNetworkInterfaceName: 'pe-nic'
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
  dependsOn: [privatelink_search_windows_net]

  resource privateEndpointName_default 'privateDnsZoneGroups' = {
    name: '${privateEndpointName}-default'
    location: 'global'
    properties: {
      privateDnsZoneConfigs: [
        {
          name: 'privatelink-search-windows-net'
          properties: {
            privateDnsZoneId: privatelink_search_windows_net.id
          }
        }
      ]
    }
  }
  
}
