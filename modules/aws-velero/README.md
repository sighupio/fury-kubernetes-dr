# AWS Velero

This terraform module provides an easy way to generate Velero required cloud resources (S3 and IAM) to backup Kubernetes objects and trigger volume snapshots.

## Requirements

|   Name    | Version  |
| --------- | -------- |
| terraform | `0.15.4` |
| aws       | `3.37.0` |

## Providers

| Name | Version  |
| ---- | -------- |
| aws  | `3.37.0` |

## Resources

|                                                                          Name                                                                          |    Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [aws_iam_access_key.velero_backup](https://registry.terraform.io/providers/hashicorp/aws/3.37.0/docs/resources/iam_access_key)                         | resource    |
| [aws_iam_policy.velero_backup](https://registry.terraform.io/providers/hashicorp/aws/3.37.0/docs/resources/iam_policy)                                 | resource    |
| [aws_iam_policy_attachment.velero_backup](https://registry.terraform.io/providers/hashicorp/aws/3.37.0/docs/resources/iam_policy_attachment)           | resource    |
| [aws_iam_role.velero_backup](https://registry.terraform.io/providers/hashicorp/aws/3.37.0/docs/resources/iam_role)                                     | resource    |
| [aws_iam_role_policy_attachment.velero_backup](https://registry.terraform.io/providers/hashicorp/aws/3.37.0/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_iam_user.velero_backup_user](https://registry.terraform.io/providers/hashicorp/aws/3.37.0/docs/resources/iam_user)                                | resource    |
| [aws_s3_bucket.backup_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.37.0/docs/resources/s3_bucket)                                   | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.37.0/docs/data-sources/caller_identity)                          | data source |

## Inputs

|         Name         |              Description              |     Type      | Default | Required |
| -------------------- | ------------------------------------- | ------------- | ------- | :------: |
| backup\_bucket\_name | Backup Bucket Name                    | `string`      | n/a     |   yes    |
| oidc\_provider\_url  | URL of OIDC issuer discovery document | `string`      | `""`    |    no    |
| tags                 | Custom tags to apply to resources     | `map(string)` | `{}`    |    no    |

## Outputs

|            Name            |               Description               |
| -------------------------- | --------------------------------------- |
| backup\_storage\_location  | Velero Cloud BackupStorageLocation CRD  |
| cloud\_credentials         | Velero required file with credentials   |
| service\_account           | Velero ServiceAccount                   |
| volume\_snapshot\_location | Velero Cloud VolumeSnapshotLocation CRD |

## Usage

```hcl
module "velero" {
  source             = "../vendor/modules/aws-velero"
  backup_bucket_name = "my-cluster-staging-velero"
  tags               = {
    "my-key": "my-value"
  }
}
```

To use IAM Roles for Service Accounts (IRSA):

```hcl
data "aws_eks_cluster" "this" {
  name = "my-cluster-staging"
}

module "velero" {
  source             = "../vendor/modules/aws-velero"
  backup_bucket_name = "my-cluster-staging-velero"
  oidc_provider_url  = replace(data.aws_eks_cluster.this.identity.0.oidc.0.issuer, "https://", "")
  tags               = {
    "my-key": "my-value"
  }
}
```

For more information about IAM Roles for Service Accounts to inject AWS credentials inside Velero's pods, click [here](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)
