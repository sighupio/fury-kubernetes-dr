# AWS Velero

This terraform module provides an easy way to generate Velero required cloud resources (S3 and IAM) to backup
Kubernetes objects and trigger volume snapshots.

## Inputs

| Name                 | Description                            | Type          | Default | Required |
| -------------------- | -------------------------------------- | ------------- | ------- | :------: |
| backup\_bucket\_name | Backup Bucket Name                     | `string`      | n/a     |   yes    |
| tags                 | Custom tags to apply to resources      | `map(string)` | `{}`    |   no     |

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
  backup_bucket_name = "my-cluster-staging-velero"
  project            = "sighup-staging"
  tags               = {
    "my-key": "my-value"
  }
}
```

## Links

- [https://github.com/vmware-tanzu/velero-plugin-for-aws/tree/v1.2.0#setup](https://github.com/vmware-tanzu/velero-plugin-for-aws/tree/v1.2.0#setup)
- [https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.2.0/backupstoragelocation.md](https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.2.0/backupstoragelocation.md)
- [https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.2.0/volumesnapshotlocation.md](https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.2.0/volumesnapshotlocation.md)
