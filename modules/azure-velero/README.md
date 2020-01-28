# azure-velero

This module si useful to create all the needed resources for velero to be
provisioned and work with Azure.

| WARNING: This module is meant to work with velero versions from 1 upwards. |
| --- |

## Usage
```hcl
module "azure-velero" {
  source                     = "../vendor/modules/azure-velero"
  cluster_name               = "sighup"
  environment                = "production"
  backup_bucket_name         = "sighup-production-cluster-backup"
  aks_resource_group_name    = "XXX"
  velero_resource_group_name = "XXX"
}
