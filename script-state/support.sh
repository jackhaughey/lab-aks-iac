#!/bin/bash

RESOURCE_GROUP_NAME=tfstate-rg
STORAGE_ACCOUNT_NAME=tfstateaks2026
CONTAINER_NAME=tfstate


# Create resource group
az group create \
    --name $RESOURCE_GROUP_NAME \
    --location uksouth

# Create storage account environments
az storage account create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $STORAGE_ACCOUNT_NAME \
    --sku Standard_LRS \
    --encryption-services blob

# Create blob containers environments
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_ACCOUNT_NAME
