#!/usr/bin/env bash
set -euo pipefail

LOCATION="uksouth"
TEMPLATE="bicep/environments/prod.bicep"

TENANT_ID=$(az account show --query tenantId -o tsv)

echo "Deploying PROD environment..."
az deployment sub create \
  --name "prod-aks-$(date +%Y%m%d%H%M%S)" \
  --location "$LOCATION" \
  --template-file "$TEMPLATE" \
  --parameters tenantId="$TENANT_ID"

echo "PROD deployment complete."