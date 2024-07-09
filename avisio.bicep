@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name of the Event Hub Namespace')
param eventHubNamespaceName string = 'dev${uniqueString(resourceGroup().id)}'

@description('Name of the Event Hub')
param eventHubName string = 'dev${uniqueString(resourceGroup().id)}'

@description('Name of the Azure App Configuration')
param appConfigName string = 'dev${uniqueString(resourceGroup().id)}'

// Event Hub Namespace
resource eventHubNamespace 'Microsoft.EventHub/namespaces@2024-01-01' = {
  name: eventHubNamespaceName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {
    isAutoInflateEnabled: true
    maximumThroughputUnits: 20
  }
}

// Event Hub
resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2024-01-01' = {
  parent: eventHubNamespace
  name: eventHubName
  location: location
  properties: {
    messageRetentionInDays: 7
    partitionCount: 4
    status: 'Active'
  }
  dependsOn: [
    eventHubNamespace
  ]
}

// Azure App Configuration
resource appConfig 'Microsoft.AppConfiguration/configurationStores@2021-03-01-preview' = {
  name: appConfigName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {}
}

output eventHubNamespaceId string = eventHubNamespace.id
output eventHubId string = eventHub.id
output appConfigId string = appConfig.id
