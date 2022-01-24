# Velero

![Velero Logo](../../docs/assets/velero.png)

- [Velero](#velero)
  - [Requirements](#requirements)
  - [Server deployment](#server-deployment)
    - [Velero on-premises](#velero-on-premises)
    - [Velero on AWS](#velero-on-aws)
    - [Velero on GCP](#velero-on-gcp)
    - [Velero on Azure](#velero-on-azure)
    - [Velero Restic](#velero-restic)
    - [Velero schedule](#velero-schedule)

<!-- <KFD-DOCS> -->

Velero *(formerly Heptio Ark)* gives you tool to back up and restore your Kubernetes cluster resources and persistent
volumes. You can run Velero with a cloud provider or on-premises. Velero lets you:

- Take backups of your cluster and restore in case of loss.
- Migrate cluster resources to other clusters.
- Replicate your production cluster to development and testing clusters.

Velero consists of:

- A server that runs on your cluster
- A command-line client that runs locally

## Requirements

Velero requires to have already deployed the [prometheus-operator](https://github.com/coreos/prometheus-operator) CRDs
as this feature deploys [a `ServiceMonitor` definition](velero-base/serviceMonitor.yaml). It can be deployed using the
[fury-kubernetes-monitoring](https://github.com/sighupio/fury-kubernetes-monitoring) KFD core module.

## Server deployment

Every velero deployment, does not matter if on-premises or in any of the supported cloud, can configure
[schedules](#velero-schedule) to back up all cluster manifests and/or cluster persistence volumes.

### Velero on-premises

The [velero-on-prem](./velero-on-prem/) feature deploys a [MinIO](https://min.io/) instance in the same cluster as
object storage backend that Velero can use to store backup data.

*Example `kustomization.yaml` file*

```yaml
namespace: kube-system

bases:
  - katalog/velero/velero-on-prem
```

### Velero on AWS

The [AWS deployment alternative](./velero-aws) requires to have created `cloud-credentials` secret in the
`kube-system` namespace.
You can find a [terraform module](../../modules/aws-velero) designed to create all necessary cloud resources
to make velero works in AWS.

You can find and example terraform project using the [aws-velero](../../modules/aws-velero) terraform module
[here](../../example/aws-example/main.tf)

```bash
$ cd example/aws-example
$ terraform init
# omitted output
$ terraform apply --var="my_cluster_name=kubernetes-cluster-and-velero"
# omitted output
$ terraform output -raw cloud_credentials > /tmp/cloud_credentials.config
$ terraform output -raw volume_snapshot_location > /tmp/volume_snapshot_location.yaml
$ terraform output -raw backup_storage_location > /tmp/backup_storage_location.yaml
$ kubectl apply -f /tmp/cloud_credentials.config -n kube-system
# omitted output
$ kubectl apply -f /tmp/volume_snapshot_location.yaml -n kube-system
# omitted output
$ kubectl apply -f /tmp/backup_storage_location.yaml -n kube-system
# omitted output
```

Then, you will be able to deploy the velero AWS deployment.

*Example `kustomization.yaml` file*

```yaml
namespace: kube-system

bases:
  - katalog/velero/velero-aws
```

More information about the [AWS Velero Plugin](https://github.com/vmware-tanzu/velero-plugin-for-aws)

### Velero on GCP

The [GCP deployment alternative](./velero-gcp) requires to have created `cloud-credentials` secret in the
`kube-system` namespace.
You can find a [terraform module](../../modules/gcp-velero) designed to create all necessary cloud resources
to make velero works in GCP.

Then, you will be able to deploy the velero GCP deployment.

*Example `kustomization.yaml` file*

```yaml
namespace: kube-system

bases:
  - katalog/velero/velero-gcp
```

More information about the [GCP Velero Plugin](https://github.com/vmware-tanzu/velero-plugin-for-gcp)

### Velero on Azure

The [Azure deployment alternative](./velero-azure) requires to have created `cloud-credentials` secret in the
`kube-system` namespace.
You can find a [terraform module](../../modules/azure-velero) designed to create all necessary cloud resources
to make velero works in Azure.

Then, you will be able to deploy the velero Azure deployment.

*Example `kustomization.yaml` file*

```yaml
namespace: kube-system

bases:
  - katalog/velero/velero-azure
```

More information about the [Azure Velero Plugin](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure)

### Velero Restic

Velero has support for backing up and restoring Kubernetes volumes using a free open-source backup tool called restic.

[velero-restic](./velero-restic) requires to have a velero deployment running in the cluster before deploy it.
Velero restic is not tied to be deployed on prem or on cloud. So feel free to deploy it with your prefered velero
deployment.

```yaml
namespace: kube-system

bases:
  - katalog/velero/velero-aws
  - katalog/velero/velero-restic
```

More information about [Velero Restic integration](https://velero.io/docs/v1.3.1/restic/)

### Velero schedule

This module contains a couple of useful [velero schedules](velero-schedules) to perform automatic backups of cluster manifests and/or
persistence volumes.

Feel free to deploy these schedules if fits in your business:

```yaml
namespace: kube-system

bases:
  - katalog/velero/velero-aws
  - katalog/velero/velero-schedules
```

More information about
[velero schedules](https://github.com/vmware-tanzu/velero/blob/master/site/docs/master/api-types/schedule.md)

<!-- </KFD-DOCS> -->
