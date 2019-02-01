# aws-ark

This module is useful to create all the things necessary for ark to work and to be provisioned

# Usage
```hcl
module "aws-ark" {
    source = "../vendor/modules/aws-ark"
    cluster_name = "pippo"
    environment = "production"
    aws_region = "eu-west-1"
    ark_backup_bucket_name = "sighup-pluto"
}
```