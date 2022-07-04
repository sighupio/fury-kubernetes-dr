# OKE Velero

This terraform module provides an easy way to generate Velero required cloud resources (Object Storage and IAM) to backup Kubernetes objects and trigger volume snapshots.

## Requirements

|   Name    | Version  |
| --------- | -------- |
| terraform | `1.2.2`  |
| oci       | `4.79.0` |

## Providers

| Name | Version  |
| ---- | -------- |
| oci  | `4.79.0` |

## Resources

|                                                                          Name                                                                          |    Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [oci_objectstorage_bucket](https://registry.terraform.io/providers/oracle/oci/4.79.0/docs/resources/objectstorage_bucket)                              | resource    |
| [oci_identity_user](https://registry.terraform.io/providers/oracle/oci/4.79.0/docs/resources/identity_user)                                            | resource    |
| [oci_identity_group](https://registry.terraform.io/providers/oracle/oci/4.79.0/docs/resources/identity_group)                                          | resource    |
| [oci_identity_user_group_membership](https://registry.terraform.io/providers/oracle/oci/4.79.0/docs/resources/identity_user_group_membership)          | resource    |
| [oci_identity_customer_secret_key](https://registry.terraform.io/providers/oracle/oci/4.79.0/docs/resources/identity_customer_secret_key)              | resource    |
| [oci_identity_policy](https://registry.terraform.io/providers/oracle/oci/4.79.0/docs/resources/identity_policy)                                        | resource    |

## Inputs

|         Name             |              Description              |     Type      | Default | Required |
| ------------------------ | ------------------------------------- | ------------- | ------- | :------: |
| backup\_bucket\_name     | Backup Bucket Name                    | `string`      | n/a     |   yes    |
| backup\_compartment\_id  | Compartment OCID where the bucket is  | `string`      | n/a     |   yes    |
| tenancy\_ocid            | Tenancy OCID                          | `string`      | n/a     |   yes    |
| region                   | OCI Region                            | `string`      | n/a     |   yes    |
| object-storage-namespace | Object storage namespace              | `string`      | n/a     |   yes    |
| tags                     | Custom tags to apply to resources     | `map(string)` | `{}`    |    no    |

## Outputs

|            Name            |               Description               |
| -------------------------- | --------------------------------------- |
| backup\_storage\_location  | Velero Cloud BackupStorageLocation CRD  |
| cloud\_credentials         | Velero required file with credentials   |
| volume\_snapshot\_location | Velero Cloud VolumeSnapshotLocation CRD |

## Usage

```hcl
module "velero" {
  source                   = "../vendor/modules/oke-velero"
  backup_bucket_name       = "my-cluster-staging-velero"
  tenancy_ocid             = "ocid1.tenancy.oc1..."
  backup_compartment_id    = "ocid1.compartment.oc1..."
  region                   = "eu-milan-1"
  object-storage-namespace = "mycluster"
  tags               = {
    "my-key": "my-value"
  }
}
```
