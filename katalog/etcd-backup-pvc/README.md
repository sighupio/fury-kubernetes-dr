# ETCD Backup PVC

This package provides an automated solution for backing up ETCD data to a Persistent Volume Claim present in the cluster.

## Overview

This package creates a CronJob that:

1. Takes a snapshot of the ETCD database
2. Copies the snapshot to a defined PersistentVolumeName
3. Cleans up old backups based on a configurable retention policy

The job is scheduled to run on one of the available control plane nodes and uses `rclone` to manage the actual backup and its lifecycle.

The job is fault-tolerant, as it tries to backup the available etcd nodes:
even if one of the etcd nodes (if you're in a HA-setup) is failing,
`etcd-backup-pvc` asks the cluster which nodes are healthy and spashots one of
them.

> [!NOTE]
> The job is configured to use the Host Network, as a consequence it cannot resolve service names internal to the cluster or connect to them via the internal Kubernetes network.

## Requirements

- A Kubernetes cluster with ETCD
- Access to control plane nodes
- A pre-provisioned PersistentVolumeClaim

> [!NOTE]
> By default we rely on `ClusterConfiguration` found inside the `kubeadm-config` ConfigMap to
> extract the ETCD server endpoints. If you want to use a cluster that's not managed by
> `kubeadm`, please make sure to remove the `kubeadm-config` volume, and pass the CronJob the
> `ETCDCTL_ENDPOINTS` environment variable set accordingly.

## Configuration

### Default Configuration

The package includes the following default configuration:

- The backup runs on specified schedule (configurable)
- Snapshots are stored in the format `<my-custom-prefix>YYYYMMDDHHMM.etcdb`, the prefix is configurable by the user, using `kustomize`.
- Backups are uploaded to the configured PersistentVolumeClaim
- Old backups are cleaned up based on the retention policy

### Components

- **CronJob**: Orchestrates the backup process
- **ConfigMaps**:
  - `etcd-backup-pvc-config`: Contains retention settings and the prefix to be used for the backup names
  - `etcd-backup-pvc-certificates-location`: Contains ETCD connection parameters

## Usage

### Basic Installation

1. Apply the package using kustomize:

```bash
kubectl apply -k /path/to/etcd-backup-pvc
```

### Customization

To customize the package, create your own `kustomization.yaml` that references this package:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - /path/to/etcd-backup-pvc

# Override configurations as needed
patches:
  - patch: |-
      apiVersion: batch/v1
      kind: CronJob
      metadata:
        name: etcd-backup-pvc
      spec:
        schedule: "0 1 * * *"  # Run at 1:00 AM daily
  - patch: |-
      - op: replace
        path: /spec/jobTemplate/spec/template/spec/volumes/2/persistentVolumeClaim/claimName
        value: my-own-pvc
    target:
      group: batch
      version: v1
      kind: CronJob
      name: etcd-backup-pvc

# Override configmaps
configMapGenerator:
  - name: etcd-backup-pvc-config
    behavior: replace # this is important, because a configMap is already defined with some defaults
    literals:
      - backup-prefix=my-custom-prefix-
      - retention=30d  # Keep backups for 30 days
```

### Configuration Options

#### Schedule

You can modify the backup schedule using cron syntax:

| Schedule | Description |
|----------|-------------|
| `0 1 * * *` | Daily at 1:00 AM |
| `0 */6 * * *` | Every 6 hours |
| `0 0 * * 0` | Weekly on Sunday at midnight |

By default, it runs every day at 1AM.

#### Target

Backups are automatically saved at the root of the PVC volume. The name follows the following format: `<my-custom-prefix>YYYYMMDDHHMM.etcdb`.

The prefix is configurable by setting the `backup-prefix` field inside the `etcd-backup-pvc-config` ConfigMap. By default, it's set as `my-pvc-etcd-backup-`.

#### Retention

Specifies how long backups should be kept before automatic deletion (follows the rclone `--min-age` format):

| Value | Description |
|-------|-------------|
| `10d` | 10 days |
| `1w` | 1 week |
| `3M` | 3 months |

By default, it's set to `10d`.

## Security Considerations

- The CronJob runs with host network access to connect to the local ETCD instance
- It mounts the ETCD certificates from the host to authenticate and container root access is thus required

## Troubleshooting

Check the job logs for detailed error messages:

```bash
kubectl logs -n kube-system job/etcd-backup-pvc-<job-id> --all-containers
```
