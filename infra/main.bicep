// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

@description('The location where the resource is created.')
param location string = resourceGroup().location

@description('Azure Open AI SKU value')
param openAiSku string = 'S0'

@description('App Service SKU value')
param appServiceSku string = 'S1'

@description('The pricing tier of the search service you want to create')
param cogSearchSku string = 'basic'

@description('The name of the search service')
param cogSearchName string = '${uniqueString(resourceGroup().id)}-cog-search-service'

@description('The name of the Azure Open AI service')
param openAIName string = '${uniqueString(resourceGroup().id)}-openaiservice'

@description('The name of the app service')
param appServiceName string = '${uniqueString(resourceGroup().id)}-appservice'

@description('The name of the private endpoint')
param privateEndpointName string = '${uniqueString(resourceGroup().id)}-privateendpoint'

@description('The name of the private endpoint')
param openAiPrivateEndpointName string = '${uniqueString(resourceGroup().id)}-openai-privateendpoint'

@description('The name of the virtual network link')
param virtualNetworkLinkName string = '${uniqueString(resourceGroup().id)}-virtualnetworklink'

var vnetName = '${uniqueString(resourceGroup().id)}-vnet'
var subnetName = '${uniqueString(resourceGroup().id)}-subnet'
var pepSubnetName = '${uniqueString(resourceGroup().id)}-pep-subnet'
var openAiPepSubnetName = '${uniqueString(resourceGroup().id)}-openai-pep-subnet'


module vnet './vnet.bicep' = {
  name: vnetName
  params: {
    location: location
    subnetName: subnetName
    pepSubnetName: pepSubnetName
    openAiPepSubnetName: openAiPepSubnetName
    vnetName: vnetName
  }
}

module appService './app_service.bicep' = {
  name: appServiceName
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
  name: openAIName
  params: {
    location: location
    openAIName: openAIName
    sku: openAiSku
    vnetName: vnetName
    subnetName: subnetName
    resourceGroup: resourceGroup().name
    subscriptionId: subscription().id
  }
  dependsOn: [
    vnet
  ]
}

module cognitiveSearch './cognitive_search.bicep' = {
  name: cogSearchName
  params: {
    location: location
    cogSearchSku: cogSearchSku
    cogServiceName: cogSearchName
  }
  dependsOn: [
    vnet
  ]
}

module privateEndpointCognitiveSearch './private_endpoint_cognitivesearch.bicep' = {
  name: privateEndpointName
  params: {
    cognitiveSearchService: cogSearchName
    location: location
    privateEndpointName: privateEndpointName
    pepSubnetName: pepSubnetName
    vnetName: vnetName
    virtualNetworkId:virtualNetworkLinkName
  }
  dependsOn: [
    openAi
  ]
}

module privateEndpointOpenAi './private_endpoint_openai.bicep' = {
  name: openAiPrivateEndpointName
  params: {
    openAiName: openAIName
    location: location
    privateEndpointOpenAiName: openAiPrivateEndpointName
    openAiSubnetName: openAiPepSubnetName
    vnetName: vnetName
  }
  dependsOn: [
    openAi
    vnet
  ]
}



