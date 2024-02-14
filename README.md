# Project Name

Sets up a sample Azure OpenAI infrastructure project with security considered

![image](openaidiagrampe.svg)

- Azure OpenAI is only accessible from this VNET. Please see more information here: https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks?tabs=portal

## Features

This project framework provides the following features:

- Sets up app service, Azure OpenAI service, cognitive search service, private endpoint, and VNet

## Getting Started

### Prerequisites

- Add bicep extension to Visual Studio Code (if developing)

### Quickstart

1. git clone https://github.com/Azure-Samples/openai-enterprise-iac.git
2. az group create --name [resourceGroupName] --location [location]
3. az deployment group create --name [deploymentName] --resource-group [resourceGroupName] --template-file ["path to main.bicep"]

## Resources

- https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks?tabs=portal
- https://learn.microsoft.com/en-us/azure/ai-services/openai/overview
- https://learn.microsoft.com/ja-jp/azure/ai-services/what-are-ai-services
