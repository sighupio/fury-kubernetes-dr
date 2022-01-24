<h1>
    <img src="https://github.com/sighupio/fury-distribution/blob/master/docs/assets/fury-epta-white.png?raw=true" align="left" width="90" style="margin-right: 15px"/>
    Kubernetes Fury DR
</h1>

![Release](https://img.shields.io/github/v/release/sighupio/fury-kubernetes-dr?label=Latest%20Release)
![License](https://img.shields.io/github/license/sighupio/fury-kubernetes-dr?label=License)
[![Slack](https://img.shields.io/badge/slack-@kubernetes/fury-yellow.svg?logo=slack&label=Slack)](https://kubernetes.slack.com/archives/C0154HYTAQH)

<!-- <KFD-DOCS> -->

**Kubernetes Fury DR** implements backups and disaster recovery for the [Kubernetes Fury Distribution (KFD)][kfd-repo] using [Velero][velero-page].

If you are new to KFD please refer to the [official documentation][kfd-docs] on how to get started with KFD.

## Overview

**Kubernetes Fury DR** module is based on [Velero][velero-page] and velero-restic.

Velero allows you to:

- backup your cluster
- restore your cluster in case of problems
- migrate cluster resources to other clusters
- replicate your production environment to development and testing environment.

Together with Velero, velero-restic allows you to:

- backup Kubernetes volumes
- restore Kubernetes volumes

The module contains also packages to natively integrate with volumes of different cloud providers.

## Packages

Kubernetes Fury DR provides the following packages:

|                      Package                      | Version |                                   Description                                    |
| ------------------------------------------------- | ------- | -------------------------------------------------------------------------------- |
| [velero](katalog/velero)                          | `1.7.1` | Backup and restore, perform disaster recovery, and migrate Kubernetes cluster resources and persistent volumes. |

The velero package contains the following additional components:

| [velero-restic](katalog/velero/velero-restic)     | Incremental backup and restore of Kubernetes volumes. |
| [velero-schedule](katalog/velero/velero-schedule) | Common schedules for backup |

We provide terraform modules to deploy the necessary infrastructure to persist the backups natively in cloud providers:

| [aws-velero](modules/aws-velero)     | Creates AWS resources and Kubernetes CRDs to persist backups.                     |
| [eks-velero](modules/eks-velero)     | Creates AWS resources and Kubernetes CRDs to persist backups from an EKS cluster. |
| [azure-velero](modules/azure-velero) | Creates Azure resources and Kubernetes CRDs to persist backups.                   |
| [gcp-velero](modules/gcp-velero)     | Creates GCP resources and Kubernetes CRDs to persist backups.                     |

## Compatibility

| Kubernetes Version |   Compatibility    |                        Notes                        |
| ------------------ | :----------------: | --------------------------------------------------- |
| `1.20.x`           | :white_check_mark: | No known issues                                     |
| `1.21.x`           | :white_check_mark: | No known issues                                     |
| `1.22.x`           | :white_check_mark: | No known issues                                     |
| `1.23.x`           |     :warning:      | Conformance tests passed. Not officially supported. |

Check the [compatibility matrix][compatibility-matrix] for additional informations about previous releases of the modules.

## Usage

**Kubernetes Fury DR**  deployments depends on the environment:

> TODO: Specify the type of volume use a storage backend for velero

|               Environment               | Volume |
| --------------------------------------- | ------ |
| [Velero on EKS](#velero-on-eks)         | Volume |
| [Velero on AWS](#velero-on-aws)         | Volume |
| [Velero on GCP](#velero-on-gcp)         | Volume |
| [Velero on Azure](#velero-on-azure)     | Volume |
| [Velero on-premise](#velero-on-premise) | MinIo  |

### Prerequisites

|            Tool             |  Version  |                                                                          Description                                                                           |
| --------------------------- | --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [furyctl][furyctl-repo]     | `>=0.6.0` | The recommended tool to download and manage KFD modules and their packages. To learn more about `furyctl` read the [official documentation][furyctl-repo].     |
| [kustomize][kustomize-repo] | `>=3.5.0` | Packages are customized using `kustomize`. To learn how to create your customization layer with `kustomize`, please refer to the [repository][kustomize-repo]. |
| [terraform][terraform-page] | `=0.15.4` | Additional infrastructure is deployed using `terraform`.                                                                                                       |

### Velero on EKS

### Velero on AWS

### Velero on GCP

It is base on [Velero GCP Plugin](https://github.com/vmware-tanzu/velero-plugin-for-gcp)

The [GCP deployment alternative](https://github.com/sighupio/fury-kubernetes-dr/tree/master/katalog/velero/velero-gcp) requires the `cloud-credentials` `secret`config in the `kube-system` namespace.

To deploy velero on GCP:

1. List the packages you want to deploy and their version in a `Furyfile.yml`

```yaml
bases:
  - name: velero/velero-gcp
    version: "v1.9.0"
  - name: velero/velero-restic
    version: "v1.9.0"
  - name: velero/velero-schedules
    version: "v1.9.0"

modules:
  
```

> See `furyctl` [documentation][furyctl-repo] for additional details about `Furyfile.yml` format.

2. Execute `furyctl vendor -H` to download the packages

3. Inspect the download packages under `./vendor/katalog/velero`.

4. Deploy the necessary infrastructure via terraform using the `gcp-velero` terraform module:

```hcl
module "velero" {
  source             = "path/to/vendor/modules/gcp-velero"
  backup_bucket_name = "my-cluster-velero"
  project            = "sighup-staging"
}
```

> More information of modules inputs can be found in the [gcp-velero](modules/gcp-velero) module documentation
>
> [Here](https://github.com/sighupio/fury-kubernetes-dr/tree/master/example/gcp-example/main.tf) you can find an example designed to create all necessary cloud resources for Velero on GCP.

4. Define a `kustomization.yaml` that includes the downloaded resources.

```yaml
resources:
- ./vendor/katalog/velero/velero-gcp
- ./vendor/katalog/velero/velero-restic
- ./vendor/katalog/velero/velero-schedules
```

5. To deploy the packages to your cluster, execute:

```bash
kustomize build . | kubectl apply -f -
```

### Velero on Azure

#### Velero on-premises

[velero-on-prem][velero-on-prem-repo] deploys a [MinIO][minio-page] in-cluster instance as an object storage backend for Velero.

Please note that the MinIO server is running in the same cluster that is being backed up.

To deploy velero on-premise:

1. List the packages you want to deploy and their version in a `Furyfile.yml`

```yaml
bases:
  - name: velero/velero-on-prem
    version: "v1.9.0"
  - name: velero/velero-restic
    version: "v1.9.0"
  - name: velero/velero-schedules
    version: "v1.9.0"
```

> See `furyctl` [documentation][furyctl-repo] for additional details about `Furyfile.yml` format.

2. Execute `furyctl vendor -H` to download the packages

3. Inspect the download packages under `./vendor/katalog/velero`.

4. Define a `kustomization.yaml` that includes the downloaded resources.

```yaml
resources:
- ./vendor/katalog/velero/velero-on-prem
- ./vendor/katalog/velero/velero-restic
- ./vendor/katalog/velero/velero-schedules
```

5. To deploy the packages to your cluster, execute:

```bash
kustomize build . | kubectl apply -f -
```

<!-- Links -->
[calico-page]: https://github.com/projectcalico/calico
[sighup-page]: https://sighup.io
[velero-page]: https://velero.io
[minio-page]: https://min.io/
[terraform-page]: https://www.terraform.io/
[kfd-repo]: https://github.com/sighupio/fury-distribution
[furyctl-repo]: https://github.com/sighupio/furyctl
[kustomize-repo]: https://github.com/kubernetes-sigs/kustomize
[velero-on-prem-repo]: https://github.com/sighupio/fury-kubernetes-dr/tree/master/katalog/velero/velero-on-prem
[kfd-docs]: https://docs.kubernetesfury.com/docs/distribution/
[compatibility-matrix]: https://github.com/sighupio/fury-kubernetes-dr/blob/master/docs/COMPATIBILITY_MATRIX.md
[pod-network-cidr-reference]: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#initializing-your-control-plane-node

<!-- </KFD-DOCS> -->

<!-- <FOOTER> -->

## Contributing

Before contributing, please read first the [Contributing Guidelines](docs/CONTRIBUTING.md).

### Reporting Issues

In case you experience any problem with the module, please [open a new issue](https://github.com/sighupio/fury-kubernetes-dr/issues/new/choose).

## License

This module is open-source and it's released under the following [LICENSE](LICENSE)

<!-- </FOOTER> -->
