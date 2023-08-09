param appName string
param appServicePlanName string
param location string
param vnetName string
param subnetName string
param sku string

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: vnetName
  resource privateLinkSubnet 'subnets' existing = {
    name: subnetName
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: sku
    tier: 'Standard'
  }
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    virtualNetworkSubnetId: vnet::privateLinkSubnet.id
    siteConfig: {
      netFrameworkVersion: 'v4.0'
    }
  }
}
