# Velero Schedules

This directory contains common velero resources, schedules.

## Common resources

- [Full Backup Schedule](./full.yaml)
- [Manifests Only Schedule](./manifests.yaml)

## Important

This directory does not provide any functionality by itself. Please refer to the different Velero deployment
options:

- [Velero AWS](../velero-aws/README.md)
- [Velero GCP](../velero-gcp/README.md)
- [Velero Azure](../velero-azure/README.md)
- [Velero on prem](../velero-on-prem/README.md)

These deployments can use this base to deploy pre-configure velero schedules.

### Requirement

The `full` backup Schedule requires to have defined:

- `default` VolumeSnapshotLocation in the `kube-system` namespace.

The `manifest` backup Schedule requires to have defined:

- `default` BackupStorageLocation in the `kube-system` namespace.

### *Default* VolumeSnapshotLocation

As this base creates a [`Schedule`](./full.yaml) it's required to have a `VolumeSnapshotLocation`
named `default` to automate the *full* backup creation.

This module provides a set of terraform modules ([aws](../../../modules/aws-velero), [gcp](../../../modules/gcp-velero)
and [azure](../../../modules/azure-velero)) that creates it as terraform output:


*Example GCP VolumeSnapshotLocation*

```bash
$ terraform init
$ terraform apply
$ terraform output volume_snapshot_location > /tmp/volume_snapshot_location.yaml
$ cat /tmp/volume_snapshot_location.yaml
apiVersion: velero.io/v1
kind: VolumeSnapshotLocation
metadata:
  name: default
spec:
  provider: velero.io/gcp
```

Then you are ready to apply this file in the `kube-system` namespace:

```bash
$ kubectl apply -f /tmp/volume_snapshot_location.yaml -n kube-system
# omitted output
```

### *Default* BackupStorageLocation

As this base creates a [`Schedule`](./manifests.yaml) it's required to have a `BackupStorageLocation`
named `default` to automate the *manifests* backup creation.

This module provides a set of terraform modules ([aws](../../../modules/aws-velero), [gcp](../../../modules/gcp-velero)
and [azure](../../../modules/azure-velero)) that creates it as terraform output:


*Example GCP BackupStorageLocation*

```bash
$ terraform init
# omitted output
$ terraform apply
# omitted output
$ terraform output backup_storage_location > /tmp/backup_storage_location.yaml
# omitted output
$ cat /tmp/backup_storage_location.yaml
apiVersion: velero.io/v1
kind: BackupStorageLocation
metadata:
  name: default
spec:
  provider: velero.io/gcp
  objectStorage:
    bucket: my-gcs-velero-bucket
    prefix: velero
```

Then you are ready to apply this file in the `kube-system` namespace:

```bash
$ kubectl apply -f /tmp/backup_storage_location.yaml -n kube-system
# omitted output
```

If you choose to deploy the [velero on prem package](../velero-on-prem), this resource is preconfigured in the cluster.

## License

For license details please see [LICENSE](../../../LICENSE)
