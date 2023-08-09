// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

@description('The project name or prefix for all resources.')
param name string = 'openaiproject'

@description('The location where the resource is created.')
param location string = resourceGroup().location

@description('Open AI SKU value')
param openAiSku string = 'S0'

@description('App Service SKU value')
param appServiceSku string = 'S1'

@description('VNet Name')
param vnetName string = '${resourceGroup().name}-vnet'

@description('Subnet Name')
param subnetName string = '${resourceGroup().name}-subnet'

@description('Private endpoint subnet Name')
param pepSubnetName string = '${resourceGroup().name}-pep-subnet'

@description('The pricing tier of the search service you want to create')
@allowed([
  'basic'
  'standard'
])
param cogSearchSku string = 'basic'

@description('The name of the search service')
param cogServiceName string = '${resourceGroup().name}-cog-search-service-smn'

@description('The name of the Open AI service')
param openAIName string = '${resourceGroup().name}-openaiservice'

@description('The name of the app service')
param appServiceName string = '${resourceGroup().name}-appservice'

@description('The name of the private endpoint')
param privateEndpointName string = '${resourceGroup().name}-privateendpoint'

@description('The name of the virtual network link')
param virtualNetworkLinkName string = '${resourceGroup().name}-virtualnetworklink'

module vnet './vnet.bicep' = {
  name: 'deployVnet'
  params: {
    location: location
    vnetName: vnetName
    subnetName: subnetName
    pepSubnetName: pepSubnetName
  }
}

module appService './app_service.bicep' = {
  name: 'appServices'
  params: {
    location: location
    appName: appServiceName
    appServicePlanName: 'asp'
    subnetName: subnetName
    vnetName: vnetName
    sku: appServiceSku
  }
  dependsOn: [
    vnet
  ]
}

module openAi './open_ai.bicep' = {
  name: name
  params: {
    location: location
    openAIName: openAIName
    sku: openAiSku
    vnetName: vnetName
    subnetName: subnetName
    resourceGroup: resourceGroup().name
    subscriptionId: subscription().id
    cogSearchSku: cogSearchSku
    cogServiceName: cogServiceName
  }
  dependsOn: [
    vnet
  ]
}

module privateEndpoint './private_endpoint.bicep' = {
  name: privateEndpointName
  params: {
    cognitiveSearchService: cogServiceName
    location: location
    privateEndpointName: privateEndpointName
    pepSubnetName:pepSubnetName
    vnetName:vnetName
    virtualNetworkId:virtualNetworkLinkName
  }
  dependsOn: [
    openAi
  ]
}



