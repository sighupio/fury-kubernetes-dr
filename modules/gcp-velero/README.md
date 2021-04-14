# GCP Velero

This terraform module provides an easy way to generate Velero required cloud resources (Bucket and Credentials)
to backup Kubernetes objects and trigger volume snapshots.

## Inputs

| Name                                         | Description                                                                   | Type          | Default         | Required |
|----------------------------------------------|-------------------------------------------------------------------------------|---------------|-----------------|--:-:-----|
| backup\_bucket\_name                         | Backup Bucket Name                                                            | `string`      | `n/a`           | yes      |
| project                                      | GCP Project where colocate the bucket                                         | `string`      | `n/a`           | yes      |
| gcp_service_account_name                     | Name of the gcp service account to create for velero                          | `string`      | `"velero-sa"`   | yes      |
| gcp_custom_role_name                         | Name of the gcp custom role to assign to the gcp service account              | `string`      | `"velero_role"` | yes      |
| workload_identity                            | Flag to specify if velero should use workload identity instead of credentials | `bool`        | `true`          | yes      |
| workload_identity_kubernetes_service_account | Name of the kubernetes service account that will use the workload identity    | `string`      | `velero-sa`     | yes`*`   |
| tags                                         | Custom tags to apply to resources                                             | `map(string)` | `{}`            | no       |

`*` if `workload_identity` is enabled (ignored otherwise)

## Outputs

| Name                         | Description                                                      |
|------------------------------|------------------------------------------------------------------|
| backup\_storage\_location    | Velero Cloud BackupStorageLocation CRD                           |
| cloud\_credentials           | Velero service credentials in case workload identity is not used |
| volume\_snapshot\_location   | Velero Cloud VolumeSnapshotLocation CRD                          |
| kubernetes\_service\_account | Kubernetes service account to deploy to use workload identity    |

If `workload_identity` is enabled (default behaviour):

- `cloud\_credentials` will not be present in the output
- use `kubernetes_service_account` to deploy a Kubernetes service account linked to the gcp service account.

To find out more about workload identity go to the [official documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identitys).

## Usage

With workload identity:

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

To disable workload identity:

```hcl
module "velero" {
  source             = "../vendor/modules/gcp-velero"
  backup_bucket_name = "my-cluster-staging-velero"
  project            = "sighup-staging"
  workload_identity  = false

  tags               = {
    "my-key": "my-value"
  }
}
```

## Links

- [https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.0.0/backupstoragelocation.md](https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.0.0/backupstoragelocation.md)
- [https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.0.0/volumesnapshotlocation.md](https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.0.0/volumesnapshotlocation.md)
- [https://github.com/vmware-tanzu/velero-plugin-for-aws/tree/v1.0.0#setup](https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.0.0/volumesnapshotlocation.md)
