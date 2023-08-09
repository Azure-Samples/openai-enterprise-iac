# Project Name

Sets up a sample Azure Open AI infrastructure project with security considered

## Features

This project framework provides the following features:

- Sets up app service, Azure Open AI service, cognitive search service, private endpoint, and VNET

## Getting Started

### Prerequisites

- Add bicep extension to Visual Studio Code (if developing)

### Quickstart

1. git clone https://github.com/Azure-Samples/openai-enterprise-iac.git
2. az group create --name [resourceGroupName] --location [location]
3. az deployment group create --name [deploymentName] --resource-group [resourceGroupName] --template-file ["path to main.bicep"]

## Resources

(Any additional resources or related projects)

- Link to supporting information
- Link to similar sample
- ...
