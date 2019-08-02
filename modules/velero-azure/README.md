# velero-azure

This module si useful to create all the needed resources for velero to be
provisioned and work with Azure.

| WARNING: This module is meant to work with velero versions from 1.x.x upwards. |
| --- |

## Usage
```hcl
module "velero-sighup-production" {
  source                 = "../vendor/modules/velero-azure"

  name                           = "sighup"
  env                            = "production"
  kubernetes_resource_group_name = "sighup-production-kubernetes"
  velero_resource_group_name     = "sighup-production"
}
```
