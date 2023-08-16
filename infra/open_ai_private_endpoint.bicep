// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

param privateEndpointOpenAIName string
param location string
param openAISubnetName string
param vnetName string
param openAIName string

resource openAI 'Microsoft.CognitiveServices/accounts@2022-03-01' existing = {
  name: openAIName
}

resource dnsZones 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.search.windows.net'
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: vnetName
  resource privateLinkSubnet 'subnets' existing = {
    name: openAISubnetName
  }
}


resource privateEndpointOpenAi 'Microsoft.Network/privateEndpoints@2023-04-01' = {
  location: location
  name: privateEndpointOpenAIName
  properties: {
    subnet: {
      id: vnet::privateLinkSubnet.id
    }
    customNetworkInterfaceName: 'pe-nic-openai'
    privateLinkServiceConnections: [
      {
        name: privateEndpointOpenAIName
        properties: {
          privateLinkServiceId: openAI.id
          groupIds: ['account']
        }
      }
    ]
  }
  tags: {}
  dependsOn: [dnsZones]

  resource dnsZoneGroupOpenAi 'privateDnsZoneGroups' = {
    name: '${privateEndpointOpenAIName}-default'
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
