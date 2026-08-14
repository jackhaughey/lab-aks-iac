# Private AKS Landing Zone — Terraform & Bicep Deployments

A fully‑modular, production‑grade deployment of a private Azure Kubernetes Service (AKS) cluster using:

   - Hub–spoke networking

   - Azure Firewall outbound

   - Private endpoints (ACR, Key Vault, AKS API)

   - Private DNS zones

   - Bastion for secure access

   - Separate Terraform and Bicep environment stacks

   - Clean module separation for dev → prod promotion

This repository supports two IaC engines:

   - Terraform (stateful, promotion‑friendly, CI/CD‑ready)

   - Bicep (stateless, ARM‑native, ideal for subscription‑level deployments)

---

## Architecture Overview

The landing zone implements a secure AKS pattern:

   - Private AKS API

   - No public ingress

   - Azure Firewall outbound (UDR)

   - Private ACR for image pulls

   - Private Key Vault for secrets

   - Bastion host for controlled access

   - Hub VNet hosting shared services

   - Spoke VNet hosting AKS + private endpoints

   - Private DNS zones for AKS, ACR, Key Vault

---

## Repository Structure

```
lab-aks-terraform
├── bicep
│   ├── acr-private
│   ├── aks-private
│   ├── bastion
│   ├── environments
│   ├── keyvault
│   ├── modules
│   ├── network
│   └── scripts
├── docs
├── scripts
└── terraform
    ├── environment
    │   ├── dev
    │   └── prod
    └── modules
        ├── acr-private
        ├── aks-private
        ├── bastion
        ├── keyvault
        └── network

```

## Modules (Terraform & Bicep)

Each module is environment‑agnostic and reusable.

   - AKS module — Private AKS cluster with UDR outbound

   - Network module — Hub, Spoke, subnets, UDR, private DNS

   - ACR private endpoint module

   - Key Vault private endpoint module

   - Bastion module

---

## Terrafrom Deployment

Terraform is used for stateful, promotion‑friendly deployments.

### Local Environment Files (Not Committed)

This deployment uses local environment-specific files that are **not committed** to the repository:

- `terraform/environments/dev/terraform.tfvars`
- `terraform/environments/prod/terraform.tfvars`

These files contain sensitive or environment-specific values such as:

- VNet address spaces
- AKS versions
- Private IP ranges
- Resource naming prefixes

They are intentionally excluded from version control using `.gitignore`.  
Each engineer should create their own `.tfvars` files locally before running Terraform:


### Terraform Environment Structure

```
terraform/environments/dev/
terraform/environments/prod/
```

Each environment contains:

   - main.tf — module wiring

   - providers.tf — provider config

   - backend.tf — remote state

   - variables.tf — environment inputs

   - terraform.tfvars — environment values

---

### Deploying Terraform (dev)

```
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
```

### Deploying Terraform (prod)

```
cd terraform/environments/prod
terraform init
terraform plan
terraform apply
```

## Bicep Deployment

Bicep is used for stateless subscription‑level deployments.

### Bicep Environment Structure

```
bicep/environments/dev.bicep
bicep/environments/prod.bicep
```

Each environment orchestrates:

   - Network

   - AKS

   - ACR

   - Key Vault

   - Bastion

### Deploying Bicep (dev and prod)

```
az login
az account set --subscription <SUBSCRIPTION_ID>
export TENANT_ID=$(az account show --query tenantId -o tsv)

./scripts/deploy-dev.sh
# or
./scripts/deploy-prod.sh
```

---

## Security Features

   - Private AKS API

   - No public ingress

   - Azure Firewall outbound

   - Private endpoints for ACR + Key Vault

   - Private DNS zones

   - Bastion host for controlled access

   - RBAC‑enabled Key Vault

   - Azure RBAC for AKS

---

## Outputs

Key outputs exposed by modules:

   - AKS FQDN

   - ACR login server

   - Key Vault URI

   - Bastion public IP

   - Subnet IDs

   - Private DNS zone IDs