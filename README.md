# AKS Terraform Lab — Dev/Prod Environment Setup

A fully‑modular, production‑inspired Azure Kubernetes Service (AKS) lab built with Terraform.
This repository provides two isolated environments—dev and prod—each with its own:

- Resource Group

- Virtual Network + AKS subnet

- AKS cluster

- Azure Container Registry (ACR)

- Azure Key Vault

- Terraform remote state stored in separate folders inside the same Azure Storage Account

The design follows best practices for environment isolation, module reuse, and clean CI/CD workflows.




```
alab-aks-terraform/
  modules/
    resource_group/
    network/
    aks/
    acr/
    keyvault/
  envs/
    dev/
      main.tf
      variables.tf
      terraform.tfvars
      backend.tfvars
    prod/
      main.tf
      variables.tf
      terraform.tfvars
      backend.tfvars
```
## Modules
Each module encapsulates a single Azure resource type:

- resource_group — creates the environment’s RG

- network — VNet + AKS subnet

- aks — AKS cluster

- acr — Azure Container Registry

- keyvault — Key Vault for secrets and identity integration

## Environments
Each environment folder is fully self‑contained:

- Its own backend configuration

- Its own variables

- Its own state file

- Its own AKS cluster + supporting infra

## Remote State Layout
Terraform state is stored in an Azure Storage Account:

```
tfstate/
  dev/
    terraform.tfstate
  prod/
    terraform.tfstate
```

Each environment provides its own backend override file:
```
envs/dev/backend.tfvars
```

```
key = "dev/terraform.tfstate"
```

```
envs/prod/backend.tfvars
```

```
key = "prod/terraform.tfstate"
```

This ensures complete isolation between dev and prod.

## Deploying the Lab
Prerequisites

- Azure CLI logged in

- Terraform ≥ 1.6

- Storage Account + container created for remote state

- Resource group for Terraform state (example: rg-tfstate-aks-lab)

Deploy DEV
bash

cd envs/dev
terraform init -backend-config=backend.tfvars
terraform plan
terraform apply

## Deploy PROD

```
cd envs/prod
terraform init -backend-config=backend.tfvars
terraform plan
terraform apply
```

Accessing the AKS Cluster

After deployment:

```
terraform output kube_config > kubeconfig-dev
export KUBECONFIG=./kubeconfig-dev
kubectl get nodes
```
Repeat for prod:

```
terraform output kube_config > kubeconfig-prod
export KUBECONFIG=./kubeconfig-prod
kubectl get nodes
```

## Design Principles
### 1. Environment Isolation

Each environment has:

- Its own resource group

- Its own VNet

- Its own AKS cluster

- Its own ACR

- Its own Key Vault

- Its own Terraform state

This prevents accidental cross‑environment changes.

### 2. Module Reuse

All infrastructure is built using shared modules:

- Consistent naming

- Consistent tagging

- Easy to extend

- Easy to maintain

