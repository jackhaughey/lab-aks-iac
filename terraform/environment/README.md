# Environment Differences

## Dev
- Small AKS cluster
- VM size: Standard_DS2_v2
- Node count: 1

## Prod
- Larger AKS cluster
- VM size: Standard_D4s_v5
- Node count: 3

Actual values are stored in non-committed `.tfvars` files.

## dev.tfvars
```
system_node_vm_size = "Standard_DS2_v2"
system_node_count   = 1
```

# prod.tfvars
```
system_node_vm_size = "Standard_D4s_v5"
system_node_count   = 3
```
