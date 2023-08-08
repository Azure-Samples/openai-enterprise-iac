param vnetName string
param location string
param subnetName string
param pepSubnetName string

resource virtualNetworkType_External_vnet_name_vnet 'Microsoft.Network/virtualNetworks@2020-04-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        name: subnetName
        properties: {
          serviceEndpoints: [
            {
              service: 'Microsoft.CognitiveServices'
              locations: [
                location
              ]
            }
          ]
          delegations: [
            {
              name: 'Microsoft.Web/serverFarms'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: pepSubnetName
        properties: {
          addressPrefix: '10.0.1.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}
