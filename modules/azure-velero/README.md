# Azure Velero

This terraform module provides an easy way to generate Velero required cloud resources (Object Storage and Credentials)
to backup Kubernetes objects and trigger volume snapshots.

## Provider

This module is compatible with `azurerm` terraform provider version:
[`1.44.0`](https://github.com/terraform-providers/terraform-provider-azurerm/tree/v1.44.0)

## Inputs

| Name                          | Description                                                                                                      | Type     | Default              | Required |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------- | -------- | -------------------- | :------: |
| aks\_resource\_group\_name    | Resource group name of AKS cluster to backup                                                                     | `string` | n/a                  |   yes    |
| azure\_cloud\_name            | available azure\_cloud\_name values: AzurePublicCloud, AzureUSGovernmentCloud, AzureChinaCloud, AzureGermanCloud | `string` | `"AzurePublicCloud"` |    no    |
| backup\_bucket\_name          | Backup Bucket Name                                                                                               | `string` | n/a                  |   yes    |
| env                           | Environment Name                                                                                                 | `string` | n/a                  |   yes    |
| name                          | Cluster Name                                                                                                     | `string` | n/a                  |   yes    |
| velero\_resource\_group\_name | Resouce group in which to create velero resources                                                                | `string` | n/a                  |   yes    |

## Outputs

| Name                       | Description                             |
| -------------------------- | --------------------------------------- |
| backup\_storage\_location  | Velero Cloud BackupStorageLocation CRD  |
| cloud\_credentials         | Velero required file with credentials   |
| volume\_snapshot\_location | Velero Cloud VolumeSnapshotLocation CRD |

## Usage

```hcl
module "velero" {
  source                     = "../vendor/modules/azure-velero"
  name                       = "sighup"
  env                        = "production"
  backup_bucket_name         = "sighup-production-cluster-backup"
  aks_resource_group_name    = "XXX"
  velero_resource_group_name = "XXX"
}
```

## Links

- [https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure/blob/v1.0.0/backupstoragelocation.md](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure/blob/v1.0.0/backupstoragelocation.md)
- [https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure/blob/v1.0.0/volumesnapshotlocation.md](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure/blob/v1.0.0/volumesnapshotlocation.md)
- [https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure/tree/v1.0.0#create-azure-storage-account-and-blob-container](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure/tree/v1.0.0#create-azure-storage-account-and-blob-container)
