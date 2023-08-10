// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

param sku string
param location string
param openAIName string
param vnetName string
param subnetName string
param resourceGroup string
param subscriptionId string
param cogServiceName string
param cogSearchSku string

resource name_resource 'Microsoft.CognitiveServices/accounts@2022-03-01' = {
  name: openAIName
  location: location
  kind: 'OpenAI'
  tags: null
  sku: {
    name: sku
  }
  properties: {
    customSubDomainName: toLower(openAIName)
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      defaultAction: 'Deny'
      virtualNetworkRules: json('[{"id": "${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.Network/virtualNetworks/${vnetName}/subnets/${subnetName}"}]')
      ipRules: json('[]')
    }
  }
}

resource search 'Microsoft.Search/searchServices@2022-09-01' = {
  name: cogServiceName
  location: location
  sku: {
    name: cogSearchSku
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
    publicNetworkAccess: 'disabled'
  }
}
