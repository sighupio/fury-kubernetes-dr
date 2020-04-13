# Velero Cloud

This directory contains common cloud resources.

## Common resources

- [Full Backup Schedule](./default.yml)

## Important

This directory does not provide any functionality by itself. Please refer to the different Velero Cloud deployment
options:

- [Velero AWS](../velero-aws/README.md)
- [Velero GCP](../velero-gcp/README.md)
- [Velero Azure](../velero-azure/README.md)

These deployments uses this base to deploy velero full backup Schedule configured for each cloud provider.

### Requirement

The `full` backup Schedule requires to have defined:

- `default` VolumeSnapshotLocation in the `kube-system` namespace.

### *Default* VolumeSnapshotLocation

As this base creates a [`Schedule`](./default.yml) it's required to have a `VolumeSnapshotLocation`
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
```


# License 

For license details please see [LICENSE](../../../LICENSE)
