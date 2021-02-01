# EKS Velero

This terraform module provides an easy way to generate Velero required cloud resources (S3 and IAM) to backup
Kubernetes objects and trigger volume snapshots.

> ⚠️ **Warning**: this module uses ["IAM Roles for
> ServiceAccount"](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) to inject AWS credentials inside Velero's pods



## Inputs

| Name                 | Description                            | Type          | Default | Required |
| -------------------- | -------------------------------------- | ------------- | ------- | :------: |
| backup\_bucket\_name | Backup Bucket Name                     | `string`      | n/a     |   yes    |
| oidc\_provider\_url  | EKS OIDC issuer discovery document URL | `string`      | n/a     |   yes    |
| tags                 | Custom tags to apply to resources      | `map(string)` | `{}`    |   no     |

## Outputs

| Name                       | Description                             |
| -------------------------- | --------------------------------------- |
| backup\_storage\_location  | Velero Cloud BackupStorageLocation CRD  |
| kubernetes\_patches        | Velero Kubernetes resources patches     |
| volume\_snapshot\_location | Velero Cloud VolumeSnapshotLocation CRD |

## Usage

```hcl
data "aws_eks_cluster" "this" {
  name = "my-cluster-staging"
}

module "velero" {
  source             = "../vendor/modules/eks-velero"
  backup_bucket_name = "my-cluster-staging-velero"
  oidc_provider_url  = replace(data.aws_eks_cluster.this.identity.0.oidc.0.issuer, "https://", "")
  tags = {
    "my-key": "my-value"
  }
}
```

## Links

- [https://github.com/vmware-tanzu/velero-plugin-for-aws/tree/v1.1.0#setup](https://github.com/vmware-tanzu/velero-plugin-for-aws/tree/v1.1.0#setup)
- [https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.1.0/backupstoragelocation.md](https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.1.0/backupstoragelocation.md)
- [https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.1.0/volumesnapshotlocation.md](https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.1.0/volumesnapshotlocation.md)
