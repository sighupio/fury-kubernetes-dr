# Disaster Recovery Core Module version unreleased

This new release simplifies the interface of the current modules.

## Changelog

- Simplify interface for `eks-velero` module
- Simplify interface for `aws-velero` module
- Simplify interface for `gcp-velero` module
- Simplify interface for `azure-velero` module
- Update required terraform version to 0.15.4

## Upgrade path

Replace the module interface to match the new one. Ensure you are running terraform 0.15.4.

### modules/eks-velero

Old interface:

```hcl
locals {
    eks_oidc_issuer = replace(data.aws_eks_cluster.this.identity.0.oidc.0.issuer, "https://", "")
}

module "velero" {
  source             = "../vendor/modules/eks-velero"
  name               = "my-cluster"
  env                = "test"
  backup_bucket_name = "my-cluster-velero"
  oidc_provider_url  = local.eks_oidc_issuer
  region             = "eu-west-1"
}
```

New interface:

```hcl
locals {
    eks_oidc_issuer = replace(data.aws_eks_cluster.this.identity.0.oidc.0.issuer, "https://", "")
}

module "velero" {
  source             = "../vendor/modules/eks-velero"
  backup_bucket_name = "my-cluster-velero"
  oidc_provider_url  = local.eks_oidc_issuer
  tags               = {
      "cluster" : "my-cluster",
      "env"     : "test",
      "any-key" : "any-value"
  }
}
```

### modules/aws-velero

Old interface:

```hcl
module "velero" {
  source             = "../vendor/modules/aws-velero"
  name               = "my-cluster"
  env                = "staging"
  backup_bucket_name = "my-cluster-staging-velero"
  region             = "eu-west-1"
}
```

New interface:

```hcl
module "velero" {
  source             = "../vendor/modules/aws-velero"
  backup_bucket_name = "my-cluster-staging-velero"
  tags               = {
    "my-key": "my-value"
  }
}
```

### modules/gcp-velero

Old interface:

```hcl
module "velero" {
  source             = "../vendor/modules/gcp-velero"
  name               = "my-cluster"
  env                = "staging"
  backup_bucket_name = "my-cluster-staging-velero"
  project            = "sighup-staging"
}
```

New interface:

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

### modules/azure-velero

Old interface:

```hcl
module "velero" {
  source                     = "../vendor/modules/azure-velero"
  name                       = "sighup"
  env                        = "production"
  backup_bucket_name         = "sighup-production-cluster-backup"
  aks_resource_group_name    = "XXX"
  velero_resource_group_name = "XXX"
}
```

New interface:

```hcl
module "velero" {
  source                     = "../vendor/modules/azure-velero"
  backup_bucket_name         = "sighup-production-cluster-backup"
  aks_resource_group_name    = "XXX"
  velero_resource_group_name = "XXX"
  tags                       = {
    "my-key": "my-value"
  }
}
```
