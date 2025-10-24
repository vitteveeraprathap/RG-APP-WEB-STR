// =====================
// Parameters
// =====================
param location string = 'southeastasia'

param appServicePlanName string
param webAppName string
param storageAccountName string

param keyVaultName string
param acrName string
param logAnalyticsName string

// =====================
// App Service Plan
// =====================
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'F1'
    tier: 'Free'
  }
}

// =====================
// Web App
// =====================
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

// =====================
// Storage Account
// =====================
resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
  }
}

// =====================
// Key Vault
// =====================
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableSoftDelete: true
    accessPolicies: [] // 👈 Required even if empty
  }
}

// =====================
// Azure Container Registry (ACR)
// =====================
resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

// =====================
// Log Analytics Workspace
// =====================
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

// =====================
// Outputs
// =====================
output webAppUrl string = webApp.properties.defaultHostName
output storageAccountId string = storage.id
output appServicePlanId string = appServicePlan.id
output keyVaultId string = keyVault.id
output acrId string = acr.id
output logAnalyticsId string = logAnalytics.id
