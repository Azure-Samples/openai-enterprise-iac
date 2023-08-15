// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

param privateEndpointOpenAiName string
param location string
param openAiSubnetName string
param vnetName string
param openAiName string

resource open_ai 'Microsoft.CognitiveServices/accounts@2022-03-01' existing = {
  name: openAiName
}

resource dnsZones 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.search.windows.net'
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: vnetName
  resource privateLinkSubnet 'subnets' existing = {
    name: openAiSubnetName
  }
}


resource privateEndpointOpenAi 'Microsoft.Network/privateEndpoints@2023-04-01' = {
  location: location
  name: privateEndpointOpenAiName
  properties: {
    subnet: {
      id: vnet::privateLinkSubnet.id
    }
    customNetworkInterfaceName: 'pe-nic-openai'
    privateLinkServiceConnections: [
      {
        name: privateEndpointOpenAiName
        properties: {
          privateLinkServiceId: open_ai.id
          groupIds: ['account']
        }
      }
    ]
  }
  tags: {}
  dependsOn: [dnsZones]

  resource dnsZoneGroupOpenAi 'privateDnsZoneGroups' = {
    name: '${privateEndpointOpenAiName}-default'
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
