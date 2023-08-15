param cogServiceName string
param cogSearchSku string
param location string

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
