<!-- markdownlint-disable MD033 -->
<h1>
    <img src="https://github.com/sighupio/fury-distribution/blob/main/docs/assets/fury-epta-white.png?raw=true" align="left" width="90" style="margin-right: 15px"/>
    Kubernetes Fury Disaster Recovery
</h1>
<!-- markdownlint-enable MD033 -->

![Release](https://img.shields.io/badge/Latest%20Release-v1.11.0-blue)
![License](https://img.shields.io/github/license/sighupio/fury-kubernetes-dr?label=License)
[![Slack](https://img.shields.io/badge/slack-@kubernetes/fury-yellow.svg?logo=slack&label=Slack)](https://kubernetes.slack.com/archives/C0154HYTAQH)

<!-- <KFD-DOCS> -->

**Kubernetes Fury Disaster Recovery (DR)** implements backups and disaster recovery for the [Kubernetes Fury Distribution (KFD)][kfd-repo] using [Velero][velero-page].

If you are new to KFD please refer to the [official documentation][kfd-docs] on how to get started with KFD.

## Overview

**Kubernetes Fury DR** module is based on [Velero][velero-page] and [Velero Restic][velero-restic-page].

Velero allows you to:

- backup your cluster
- restore your cluster in case of problems
- migrate cluster resources to other clusters
- replicate your production environment to development and testing environment.

Together with Velero, Velero Restic allows you to:

- backup Kubernetes volumes
- restore Kubernetes volumes

The module contains also velero plugins to natively integrate with Velero with different cloud providers and use cloud provider's volumes as the storage backend.

## Packages

Kubernetes Fury DR provides the following packages:

| Package                  | Version  | Description                                                                                                     |
| ------------------------ | -------- | --------------------------------------------------------------------------------------------------------------- |
| [velero](katalog/velero) | `1.10.1` | Backup and restore, perform disaster recovery, and migrate Kubernetes cluster resources and persistent volumes. |

The velero package contains the following additional components:

| Component                                           | Description                                           |
| --------------------------------------------------- | ----------------------------------------------------- |
| [velero-restic](katalog/velero/velero-restic)       | Incremental backup and restore of Kubernetes volumes. |
| [velero-schedules](katalog/velero/velero-schedules) | Common schedules for backup                           |

### Integration with cloud providers

Use the following Velero Plugins to integrate Velero with cloud providers:

| Plugin                                      | Description                                |
| ------------------------------------------- | ------------------------------------------ |
| [velero-aws](katalog/velero/velero-aws)     | Plugins to support running Velero on AWS   |
| [velero-gcp](katalog/velero/velero-gcp)     | Plugins to support running Velero on GCP   |
| [velero-azure](katalog/velero/velero-azure) | Plugins to support running Velero on Azure |

Deploy the necessary infrastructure to persist the backups natively in cloud providers volumes, using the following terraform modules:

| Terraform Module                     | Description                                                     |
| ------------------------------------ | --------------------------------------------------------------- |
| [aws-velero](modules/aws-velero)     | Creates AWS resources and Kubernetes CRDs to persist backups.   |
| [azure-velero](modules/azure-velero) | Creates Azure resources and Kubernetes CRDs to persist backups. |
| [gcp-velero](modules/gcp-velero)     | Creates GCP resources and Kubernetes CRDs to persist backups.   |

## Compatibility

| Kubernetes Version |   Compatibility    | Notes           |
| ------------------ | :----------------: | --------------- |
| `1.22.x`           | :white_check_mark: | No known issues |
| `1.23.x`           | :white_check_mark: | No known issues |
| `1.24.x`           | :white_check_mark: | No known issues |
| `1.25.x`           | :white_check_mark: | No known issues |

Check the [compatibility matrix][compatibility-matrix] for additional information about previous releases of the modules.

## Usage

**Kubernetes Fury DR** deployment depends on the environment.

| Environment                               | Storage Backend      | Velero Plugin                                   | Terraform Module                     |
| ----------------------------------------- | -------------------- | ----------------------------------------------- | ------------------------------------ |
| [Velero on AWS](#velero-on-aws)           | S3 Bucket            | [velero-aws](katalog/velero/velero-aws)         | [aws-velero](modules/aws-velero)     |
| [Velero on GCP](#velero-on-gcp)           | GCS                  | [velero-gcp](katalog/velero/velero-gcp)         | [gcp-velero](modules/gcp-velero)     |
| [Velero on Azure](#velero-on-azure)       | AZ Storage Container | [velero-azure](katalog/velero/velero-azure)     | [azure-velero](modules/azure-velero) |
| [Velero on-premises](#velero-on-premises) | MinIo                | [velero-on-prem](katalog/velero/velero-on-prem) | `/`                                  |

### Prerequisites

| Tool                        | Version   | Description                                                                                                                                                    |
| --------------------------- | --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [furyctl][furyctl-repo]     | `>=0.6.0` | The recommended tool to download and manage KFD modules and their packages. To learn more about `furyctl` read the [official documentation][furyctl-repo].     |
| [kustomize][kustomize-repo] | `>=3.5.0` | Packages are customized using `kustomize`. To learn how to create your customization layer with `kustomize`, please refer to the [repository][kustomize-repo]. |
| [terraform][terraform-page] | `=0.15.4` | Additional infrastructure is deployed using `terraform`.                                                                                                       |

### Velero on AWS

Velero on AWS is based on the [AWS Velero Plugin][velero-aws-plugin-repo].

It requires the secret `cloud-credentials` in the `kube-system` namespace containing a service account with appropriate credentials.
As an alternative, the module supports [authentication via IAM Roles][aws-docs-iam-roles].

To deploy Velero on AWS:

1. List the packages you want to deploy and their version in a `Furyfile.yml`

```yaml
bases:
  - name: dr/velero/velero-aws
    version: "v1.11.0"
  - name: dr/velero/velero-restic
    version: "v1.11.0"
  - name: dr/velero/velero-schedules
    version: "v1.11.0"

modules:
  - name: dr/aws-velero
    version: "v1.11.0"
```

> See `furyctl` [documentation][furyctl-repo] for additional details about `Furyfile.yml` format.

2. Execute `furyctl vendor -H` to download the packages

3. Inspect the downloaded packages under `./vendor/katalog/velero`.

4. Deploy the necessary infrastructure via terraform using the `aws-velero` terraform module:

```hcl
module "velero" {
  source             = "path/to/vendor/modules/aws-velero"
  backup_bucket_name = "my-cluster-velero"
  project            = "sighup-staging"
}
```

> More information on modules inputs can be found in the [aws-velero](modules/aws-velero) module documentation
>
> [Here][kfd-velero-aws-example] you can find an example designed to create all necessary cloud resources for Velero on AWS.

5. Define a `kustomization.yaml` that includes the downloaded resources.

```yaml
resources:
  - ./vendor/katalog/dr/velero/velero-aws
  - ./vendor/katalog/dr/velero/velero-restic
  - ./vendor/katalog/dr/velero/velero-schedules
```

6. To deploy the packages to your cluster, execute:

```bash
kustomize build . | kubectl apply -f -
```

### Velero on GCP

Velero on GCP is based on the [Velero GCP Plugin][velero-gcp-plugin-repo].

It requires the secret `cloud-credentials` in the `kube-system` namespace containing a service account with appropriate credentials.
As an alternative, the module supports workload identity.

> Check the required Velero GCP plugin permissions [here][velero-gcp-plugin-repo-permissions]

To deploy Velero on GCP:

1. List the packages you want to deploy and their version in a `Furyfile.yml`

```yaml
bases:
  - name: dr/velero/velero-gcp
    version: "v1.11.0"
  - name: dr/velero/velero-restic
    version: "v1.11.0"
  - name: dr/velero/velero-schedules
    version: "v1.11.0"

modules:
  - name: dr/gcp-velero
    version: "v1.11.0"
```

> See `furyctl` [documentation][furyctl-repo] for additional details about `Furyfile.yml` format.

2. Execute `furyctl vendor -H` to download the packages

3. Inspect the downloaded packages under `./vendor/katalog/velero`.

4. Deploy the necessary infrastructure via terraform using the `gcp-velero` terraform module:

```hcl
module "velero" {
  source             = "path/to/vendor/modules/gcp-velero"
  backup_bucket_name = "my-cluster-velero"
  project            = "sighup-staging"
}
```

> More information on modules inputs can be found in the [gcp-velero](modules/gcp-velero) module documentation
>
> [Here][kfd-velero-gcp-example] you can find an example designed to create all necessary cloud resources for Velero on GCP.

5. Define a `kustomization.yaml` that includes the downloaded resources.

```yaml
resources:
  - ./vendor/katalog/dr/velero/velero-gcp
  - ./vendor/katalog/dr/velero/velero-restic
  - ./vendor/katalog/dr/velero/velero-schedules
```

6. To deploy the packages to your cluster, execute:

```bash
kustomize build . | kubectl apply -f -
```

### Velero on Azure

Velero on Azure is based on the [Azure Velero Plugin][velero-azure-plugin-repo].

Requires the `cloud-credentials` `secret` config in the `kube-system` namespace.

To deploy Velero on Azure:

1. List the packages you want to deploy and their version in a `Furyfile.yml`

```yaml
bases:
  - name: dr/velero/velero-azure
    version: "v1.11.0"
  - name: dr/velero/velero-restic
    version: "v1.11.0"
  - name: dr/velero/velero-schedules
    version: "v1.11.0"

modules:
  - name: dr/azure-velero
    version: "v1.11.0"
```

> See `furyctl` [documentation][furyctl-repo] for additional details about `Furyfile.yml` format.

2. Execute `furyctl vendor -H` to download the packages

3. Inspect the downloaded packages under `./vendor/katalog/velero`.

4. Deploy the necessary infrastructure via terraform using the `azure-velero` terraform module:

```hcl
module "velero" {
  source             = "path/to/vendor/modules/azure-velero"
  backup_bucket_name = "my-cluster-velero"
  project            = "sighup-staging"
}
```

> More information on modules inputs can be found in the [azure-velero](modules/azure-velero) module documentation
>
> [Here][kfd-velero-azure-example] you can find an example designed to create all necessary cloud resources for Velero on Azure.

5. Define a `kustomization.yaml` that includes the downloaded resources.

```yaml
resources:
  - ./vendor/katalog/dr/velero/velero-azure
  - ./vendor/katalog/dr/velero/velero-restic
  - ./vendor/katalog/dr/velero/velero-schedules
```

6. To deploy the packages to your cluster, execute:

```bash
kustomize build . | kubectl apply -f -
```

### Velero on-premises

[velero-on-prem][kfd-velero-on-prem] deploys a [MinIO][minio-page] in-cluster instance as an object storage backend for Velero.

Please note that the MinIO server is running in the same cluster that is being backed up.

To deploy `velero on-prem`:

1. List the packages you want to deploy and their version in a `Furyfile.yml`

```yaml
bases:
  - name: velero/velero-on-prem
    version: "v1.11.0"
  - name: velero/velero-restic
    version: "v1.11.0"
  - name: velero/velero-schedules
    version: "v1.11.0"
```

> See `furyctl` [documentation][furyctl-repo] for additional details about `Furyfile.yml` format.

2. Execute `furyctl vendor -H` to download the packages

3. Inspect the downloaded packages under `./vendor/katalog/velero`.

4. Define a `kustomization.yaml` that includes the downloaded resources.

```yaml
resources:
  - ./vendor/katalog/dr/velero/velero-on-prem
  - ./vendor/katalog/dr/velero/velero-restic
  - ./vendor/katalog/dr/velero/velero-schedules
```

5. To deploy the packages to your cluster, execute:

```bash
kustomize build . | kubectl apply -f -
```

<!-- Links -->

[sighup-page]: https://sighup.io
[velero-page]: https://velero.io
[velero-restic-page]: https://velero.io/docs/main/restic/
[minio-page]: https://min.io/
[terraform-page]: https://www.terraform.io/
[kfd-repo]: https://github.com/sighupio/fury-distribution
[furyctl-repo]: https://github.com/sighupio/furyctl
[kustomize-repo]: https://github.com/kubernetes-sigs/kustomize
[velero-gcp-plugin-repo]: https://github.com/vmware-tanzu/velero-plugin-for-gcp
[velero-aws-plugin-repo]: https://github.com/vmware-tanzu/velero-plugin-for-aws
[velero-azure-plugin-repo]: https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure
[velero-gcp-plugin-repo-permissions]: https://github.com/vmware-tanzu/velero-plugin-for-gcp#set-permissions-for-velero
[kfd-velero-gcp-example]: https://github.com/sighupio/fury-kubernetes-dr/tree/master/example/gcp-example/main.tf
[kfd-velero-aws-example]: https://github.com/sighupio/fury-kubernetes-dr/tree/master/example/aws-example/main.tf
[kfd-velero-azure-example]: https://github.com/sighupio/fury-kubernetes-dr/tree/master/example/azure-example/main.tf
[kfd-velero-on-prem]: https://github.com/sighupio/fury-kubernetes-dr/tree/master/katalog/velero/velero-on-prem
[aws-docs-iam-roles]: https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
[kfd-docs]: https://docs.kubernetesfury.com/docs/distribution/
[compatibility-matrix]: https://github.com/sighupio/fury-kubernetes-dr/blob/master/docs/COMPATIBILITY_MATRIX.md

<!-- </KFD-DOCS> -->

<!-- <FOOTER> -->

## Contributing

Before contributing, please read first the [Contributing Guidelines](docs/CONTRIBUTING.md).

### Reporting Issues

In case you experience any problem with the module, please [open a new issue](https://github.com/sighupio/fury-kubernetes-dr/issues/new/choose).

## License

This module is open-source and it's released under the following [LICENSE](LICENSE)

<!-- </FOOTER> -->
