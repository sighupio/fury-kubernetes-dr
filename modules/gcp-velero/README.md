# GCP Velero

This terraform module provides an easy way to generate Velero required cloud resources (Bucket and Credentials)
to backup Kubernetes objects and trigger volume snapshots.

## Inputs

| Name                     | Description                                                                   | Type          | Default         | Required |
|--------------------------|-------------------------------------------------------------------------------|---------------|-----------------|----------|
| backup\_bucket\_name     | Backup Bucket Name                                                            | `string`      | `n/a`           | yes      |
| project                  | GCP Project where colocate the bucket                                         | `string`      | `n/a`           | yes      |
| gcp_service_account_name | Name of the gcp service account to create for velero                          | `string`      | `"velero-sa"`   | yes      |
| gcp_custom_role_name     | Name of the gcp custom role to assign to the gcp service account              | `string`      | `"velero_role"` | yes      |
| workload_identity        | Flag to specify if velero should use workload identity instead of credentials | `bool`        | `false`         | yes      |
| tags                     | Custom tags to apply to resources                                             | `map(string)` | `{}`            | no       |


## Outputs

| Name                               | Description                                                           |
|------------------------------------|-----------------------------------------------------------------------|
| `backup_storage_location`          | Velero Cloud BackupStorageLocation CRD                                |
| `cloud_credentials`                | Velero service credentials in case workload identity is not used      |
| `volume_snapshot_location`         | Velero Cloud VolumeSnapshotLocation CRD                               |
| `kubernetes_service_account_patch` | Patch for the Kubernetes service account to use workload identity     |
| `remove_velero_credentials_patch`  | Patch to remove service account credentials in velero                 |
| `remove_restic_credentials_patch`  | Patch to remove service account credentials in velero Node Agent      |

The presence of some outputs is conditional to the presence of `workload_identity`:

| Name                               | Default            | Workload Identity  |
|------------------------------------|--------------------|--------------------|
| `backup_storage_location`          | :white_check_mark: | :white_check_mark: |
| `cloud_credentials`                | :white_check_mark: | :x:                |
| `volume_snapshot_location`         | :white_check_mark: | :white_check_mark: |
| `kubernetes_service_account_patch` | :x:                | :white_check_mark: |
| `remove_velero_credentials_patch`  | :x:                | :white_check_mark: |
| `remove_restic_credentials_patch`  | :x:                | :white_check_mark: |

To find out more about workload identity go to the [official documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identitys).

## Usage

Without workload identity:

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

To enable workload identity:

```hcl
module "velero" {
  source             = "../vendor/modules/gcp-velero"
  backup_bucket_name = "my-cluster-staging-velero"
  project            = "sighup-staging"
  workload_identity  = true
  tags               = {
    "my-key": "my-value"
  }
}
```

## Links

- [https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.2.0/backupstoragelocation.md](https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.2.0/backupstoragelocation.md)
- [https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.2.0/volumesnapshotlocation.md](https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.2.0/volumesnapshotlocation.md)
- [https://github.com/vmware-tanzu/velero-plugin-for-aws/tree/v1.2.0#setup](https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.2.0/volumesnapshotlocation.md)
