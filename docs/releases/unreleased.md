# Disaster Recovery Core Module version unreleased

This new release simplifies the interface of the current modules.

## Changelog

- Simplify interface for `dr/eks` module

## Upgrade path

Replace the module interface to match the new one.

### modules/eks-velero

Old interface:

```hcl
locals {
    eks_oidc_issuer = replace(data.aws_eks_cluster.this.identity.0.oidc.0.issuer, "https://", "")
}

module "velero" {
  source             = "path/to/dr/eks-velero"
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
  source             = "path/to/dr/eks-velero"
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
