# ETCD Backup S3

This package provides an automated solution for backing up ETCD data to an S3-compatible storage service using a Kubernetes CronJob.

## Overview

This package creates a CronJob that:

1. Takes a snapshot of the ETCD database
2. Uploads the snapshot to an S3-compatible storage target
3. Cleans up old backups based on a configurable retention policy

The job is scheduled to run on one of the available control plane nodes and uses `rclone` to manage the S3 uploads and lifecycle management.

The job is fault-tolerant, as it tries to backup the available etcd nodes:
even if one of the etcd nodes (if you're in a HA-setup) is failing,
`etcd-backup-s3` asks the cluster which nodes are healthy and spashots one of
them.

> [!NOTE]
> The job is configured to use the Host Network, as a consequence it cannot resolve service names internal to the cluster or connect to them via the internal Kubernetes network.

## Requirements

- A Kubernetes cluster with ETCD
- Access to control plane nodes
- An S3-compatible storage target (like MinIO, AWS S3, etc.)
- `rclone` configuration for your S3 service

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
- Backups are uploaded to the configured S3 target
- Old backups are cleaned up based on the retention policy

### Components

- **CronJob**: Orchestrates the backup process
- **ConfigMaps**:
  - `etcd-backup-s3-config`: Contains S3 target, retention settings and the backup name prefix
  - `etcd-backup-s3-certificates-location`: Contains ETCD connection parameters
- **Secret**:
  - `etcd-backup-s3-rclone-conf`: Contains the rclone configuration

## Usage

### Basic Installation

1. Create an `rclone.conf` file with your S3 credentials in the `rclone` directory
2. Apply the package using kustomize:

```bash
kubectl apply -k /path/to/etcd-backup-s3
```

### Customization

To customize the package, create your own `kustomization.yaml` that references this package:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - /path/to/etcd-backup-s3

# Override configurations as needed
patches:
  - patch: |-
      apiVersion: batch/v1
      kind: CronJob
      metadata:
        name: etcd-backup-s3
      spec:
        schedule: "0 1 * * *"  # Run at 1:00 AM daily

# Override configmaps
configMapGenerator:
  - name: etcd-backup-s3-config
    behavior: replace # this is important, because a configMap is already defined with some defaults
    literals:
      - backup-prefix=my-custom-prefix-
      - target=s3:your-bucket-name/backups # `s3` must match with the section name in rclone.conf
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

#### Target

The S3 target follows the rclone format: `provider:bucket-name/path`.

The name follows the following format: `<my-custom-prefix>YYYYMMDDHHMM.etcdb`.

The prefix is configurable by setting the `backup-prefix` field inside the `etcd-backup-s3-config` ConfigMap.

The `provider` is defined in the `rclone.conf` file, name in the target must match the name of the section in the configuration file.

The `prefix` is defined inside the `etcd-backup-s3-config` ConfigMap.

#### Retention

Specifies how long backups should be kept before automatic deletion (follows the rclone `--min-age` format):

| Value | Description |
|-------|-------------|
| `10d` | 10 days |
| `1w` | 1 week |
| `3M` | 3 months |

## Security Considerations

- The CronJob runs with host network access to connect to the local ETCD instance
- It mounts the ETCD certificates from the host to authenticate and container root access is thus required
- The rclone configuration contains sensitive credentials and is stored as a Kubernetes Secret

## Troubleshooting

Check the job logs for detailed error messages:

```bash
kubectl logs -n kube-system job/etcd-backup-s3-<job-id> --all-containers
```
