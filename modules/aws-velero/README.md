# aws-velero

This module is useful to create all the things necessary for velero to work and to be provisioned

## Usage

```hcl
module "aws-velero" {
    source = "../vendor/modules/aws-velero"
    name = "pippo"
    env = "production"
    region = "eu-west-1"
    backup_bucket_name = "sighup-pluto"
}
```

## Links

- https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.0.0/backupstoragelocation.md
- https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/v1.0.0/volumesnapshotlocation.md
- https://github.com/vmware-tanzu/velero-plugin-for-aws/tree/v1.0.0#setup