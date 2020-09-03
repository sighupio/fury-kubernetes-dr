# GCP Velero

This terraform module provides an easy way to generate Velero required cloud resources (Bucket and Credentials)
to backup Kubernetes objects and trigger volume snapshots.

## Inputs

| Name                 | Description                           | Type     | Default | Required |
| -------------------- | ------------------------------------- | -------- | ------- | :------: |
| backup\_bucket\_name | Backup Bucket Name                    | `string` | n/a     |   yes    |
| env                  | Environment Name                      | `string` | n/a     |   yes    |
| name                 | Cluster Name                          | `string` | n/a     |   yes    |
| project              | GCP Project where colocate the bucket | `string` | n/a     |   yes    |

## Outputs

| Name                       | Description                             |
| -------------------------- | --------------------------------------- |
| backup\_storage\_location  | Velero Cloud BackupStorageLocation CRD  |
| cloud\_credentials         | Velero required file with credentials   |
| volume\_snapshot\_location | Velero Cloud VolumeSnapshotLocation CRD |

## Usage

```hcl
module "velero" {
  source             = "../vendor/modules/gcp-velero"
  name               = "my-cluster"
  env                = "staging"
  backup_bucket_name = "my-cluster-staging-velero"
  project            = "sighup-staging"
}
```

## Links

- [https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.0.0/backupstoragelocation.md](https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.0.0/backupstoragelocation.md)
- [https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.0.0/volumesnapshotlocation.md](https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.0.0/volumesnapshotlocation.md)
- [https://github.com/vmware-tanzu/velero-plugin-for-aws/tree/v1.0.0#setup](https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.0.0/volumesnapshotlocation.md)