// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

param sku string
param location string
param openAIName string
param vnetName string
param subnetName string
param resourceGroup string
param subscriptionId string

resource openAI 'Microsoft.CognitiveServices/accounts@2022-03-01' = {
  name: openAIName
  location: location
  kind: 'OpenAI'
  tags: null
  sku: {
    name: sku
  }
  properties: {
    customSubDomainName: toLower(openAIName)
    publicNetworkAccess: 'disabled'
    networkAcls: {
      defaultAction: 'Deny'
      virtualNetworkRules: json('[{"id": "${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.Network/virtualNetworks/${vnetName}/subnets/${subnetName}"}]')
      ipRules: json('[]')
    }
  }
}
