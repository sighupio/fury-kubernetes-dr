# azure-ark

This module si useful to create all the needed resources for ark to be
provisioned and work with Azure.

| WARNING: This module is meant to work with ark versions from 0.10.x upwards. |
| --- |

## Usage
```hcl
module "azure-ark" {
  source                 = "../vendor/modules/azure-ark"
  cluster_name           = "sighup"
  env                    = "production"
  region                 = "West Europe"
  tenant_id              = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  ark_backup_bucket_name = "sighup-production-cluster-backup"
}
