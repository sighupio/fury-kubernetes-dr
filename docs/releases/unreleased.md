# Disaster recovery Core Module Release x.x.x

Welcome to the latest release of the `DR` module of [`Kubernetes Fury Distribution`](https://github.com/sighupio/fury-distribution) maintained by team SIGHUP.

In this release we're adding a new package, [`etcd-backup-s3`](../../katalog/etcd-backup-s3/README.md), which handles the automated snapshot of ETCD and pushes it to a remote S3-compatible object storage (like Minio, AWS S3).

## Component Images 🚢

TODO

| Component                           | Supported Version                                                                                   | Previous Version |
|-------------------------------------|-----------------------------------------------------------------------------------------------------|------------------|
| `velero`                            | [`v1.15.0`](https://github.com/vmware-tanzu/velero/releases/tag/v1.15.0)                            | `1.14.0`         |
| `velero-plugin-for-aws`             | [`v1.11.0`](https://github.com/vmware-tanzu/velero-plugin-for-aws/releases/tag/v1.11.0)             | `1.10.0`         |
| `velero-plugin-for-microsoft-azure` | [`v1.11.0`](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure/releases/tag/v1.11.0) | `1.10.0`         |
| `velero-plugin-for-gcp`             | [`v1.11.0`](https://github.com/vmware-tanzu/velero-plugin-for-gcp/releases/tag/v1.11.0)             | `1.10.0`         |
| `snapshot-controller`               | [`v8.0.1`](https://github.com/vmware-tanzu/velero-plugin-for-gcp/releases/tag/v1.11.0)              | `-`              |

> Please refer to the individual release notes to get a detailed information on each release.

## Features 💥

- Added `etcd-backup-s3` package

## Upgrade Guide 🦮

## 🚨 Requirement 🚨
If you want to try the `etcd-backup-s3` feature you need an S3-compatible object storage server available.

### Process
To upgrade this module from v3.0.0 to vx.x.x, you need to download this new version and then:

1. Install `etcd-backup-s3`: from the `katalog/etcd-backup-s3` folder edit the file `rclone/rclone.conf`, adjust the `kustomization.yaml` and then run the following
```bash
k kustomize build | k apply -f -`
```
