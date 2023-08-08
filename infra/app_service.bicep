param appName string
param appServicePlanName string
param location string
param vnetName string
param subnetName string

resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
  name: vnetName
  resource privateLinkSubnet 'subnets' existing = {
    name: subnetName
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'S1'
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
