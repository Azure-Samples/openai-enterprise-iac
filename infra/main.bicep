// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

@description('The location where the resource is created.')
param location string = resourceGroup().location

@description('Azure Open AI SKU value')
param openAISku string = 'S0'

@description('App Service SKU value')
param appServiceSku string = 'S1'

@description('The pricing tier of the cognitive search service you want to create')
param cogSearchSku string = 'basic'

@description('The name of the search service')
param cogSearchName string = '${uniqueString(resourceGroup().id)}-cog-search-service'

@description('The name of the Azure Open AI service')
param openAIName string = '${uniqueString(resourceGroup().id)}-openaiservice'

@description('The name of the app service')
param appServiceName string = '${uniqueString(resourceGroup().id)}-appservice'

@description('The name of the cognitive search private endpoint')
param cogSearchPrivateEndpointName string = '${uniqueString(resourceGroup().id)}-cogsearch-privateendpoint'

@description('The name of the Azure Open AI private endpoint')
param openAIPrivateEndpointName string = '${uniqueString(resourceGroup().id)}-openai-privateendpoint'

@description('The name of the virtual network link')
param cogSearchVirtualNetworkLinkName string = '${uniqueString(resourceGroup().id)}-virtualnetworklink'

@description('The name of the virtual network link')
param openAIVirtualNetworkLinkName string = '${uniqueString(resourceGroup().id)}-virtualnetworklink'

var vnetName = '${uniqueString(resourceGroup().id)}-vnet'
var subnetName = '${uniqueString(resourceGroup().id)}-subnet'
var cogSearchPepSubnetName = '${uniqueString(resourceGroup().id)}-pep-subnet'
var openAIPepSubnetName = '${uniqueString(resourceGroup().id)}-openai-pep-subnet'
var appServicePlanName = 'asp'


module vnet './vnet.bicep' = {
  name: vnetName
  params: {
    location: location
    subnetName: subnetName
    pepSubnetName: cogSearchPepSubnetName
    openAIPepSubnetName: openAIPepSubnetName
    vnetName: vnetName
  }
}

module appService './app_service.bicep' = {
  name: appServiceName
  params: {
    location: location
    appName: appServiceName
    appServicePlanName: appServicePlanName
    subnetName: subnetName
    vnetName: vnet.name
    appServiceSku: appServiceSku
  }
}

module openAI './open_ai.bicep' = {
  name: openAIName
  params: {
    location: location
    openAIName: openAIName
    sku: openAISku
    vnetName: vnet.name
    subnetName: subnetName
    resourceGroup: resourceGroup().name
    subscriptionId: subscription().id
  }
}

module cognitiveSearch './cognitive_search.bicep' = {
  name: cogSearchName
  params: {
    location: location
    cogSearchSku: cogSearchSku
    cogServiceName: cogSearchName
  }
}

module cogSearchPrivateEndpoint './cognitive_search_private_endpoint.bicep' = {
  name: cogSearchPrivateEndpointName
  params: {
    cognitiveSearchService: cognitiveSearch.name
    location: location
    privateEndpointName: cogSearchPrivateEndpointName
    pepSubnetName: cogSearchPepSubnetName
    vnetName: vnet.name
    virtualNetworkId:cogSearchVirtualNetworkLinkName
  }
}

module openAIPrivateEndpoint './open_ai_private_endpoint.bicep' = {
  name: openAIPrivateEndpointName
  params: {
    openAIName: openAI.name
    location: location
    privateEndpointOpenAIName: openAIPrivateEndpointName
    openAISubnetName: openAIPepSubnetName
    vnetName: vnetName
    virtualNetworkId: openAIVirtualNetworkLinkName
  }
  dependsOn: [
    cogSearchPrivateEndpoint
  ]
}
