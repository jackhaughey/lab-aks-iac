#!/usr/bin/env bash
set -euo pipefail

LOCATION="uksouth"
TEMPLATE="bicep/environments/dev.bicep"

TENANT_ID=$(az account show --query tenantId -o tsv)

echo "Deploying DEV environment..."
az deployment sub create \
  --name "dev-aks-$(date +%Y%m%d%H%M%S)" \
  --location "$LOCATION" \
  --template-file "$TEMPLATE" \
  --parameters tenantId="$TENANT_ID"

echo "DEV deployment complete."