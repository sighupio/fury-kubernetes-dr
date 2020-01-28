# aws-velero

This module is useful to create all the things necessary for velero to work and to be provisioned

## Usage

```hcl
module "aws-velero" {
    source = "../vendor/modules/aws-velero"
    cluster_name = "pippo"
    environment = "production"
    aws_region = "eu-west-1"
    backup_bucket_name = "sighup-pluto"
}
```
