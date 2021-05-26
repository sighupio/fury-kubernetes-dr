# Fury Kubernetes DR *(Disaster Recovery)*

## Disaster Recovery Packages

The following packages are included in Fury Kubernetes Disaster Recovery katalog:

- [velero](katalog/velero): Velero (formerly Heptio Ark) gives you a tool to
back up and restore your Kubernetes cluster resources and persistent volumes. Version: **1.6.0**
- [velero-restic](katalog/velero/velero-restic): Velero has support for backing up and restoring
Kubernetes volumes using a free open-source backup tool called restic. Version: **1.6.0**

The following packages are included in Fury Kubernetes Disaster Recovery modules:

- [aws-velero](modules/aws-velero): Creates AWS resources and Kubernetes CRDs needed to persist backups.
- [eks-velero](modules/eks-velero): Creates AWS resources and Kubernetes CRDs needed to persist backups
from an eks cluster.
- [azure-velero](modules/azure-velero): Creates Azure resources and Kubernetes CRDs needed to persist backups.
- [gcp-velero](modules/gcp-velero): Creates GCP resources and Kubernetes CRDs needed to persist backups.


## Compatibility

| Module Version / Kubernetes Version | 1.14.X             | 1.15.X             | 1.16.X             | 1.17.X             | 1.18.X             | 1.19.X             | 1.20.X             | 1.21.X             |
|-------------------------------------|:------------------:|:------------------:|:------------------:|:------------------:|:------------------:|:------------------:|:------------------:|:------------------:|
| v1.0.0                              |                    |                    |                    |                    |                    |                    |                    |                    |
| v1.1.0                              |                    |                    |                    |                    |                    |                    |                    |                    |
| v1.2.0                              | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                    |
| v1.3.0                              | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                    |
| v1.3.1                              | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                    |
| v1.4.0                              |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |
| v1.5.0                              |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |     :warning:      |                    |                    |
| v1.5.1                              |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |     :warning:      |                    |                    |
| v1.6.0                              |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |     :warning:      |     :warning:      |
| v1.7.0                              |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |     :warning:      |

- :white_check_mark: Compatible
- :warning: Has issues
- :x: Incompatible

### Warning

- :warning: : module version: `v1.6.0` and Kubernetes Version: `1.20.x`. It works as expected. Marked as warning
because it is not officially supported by [SIGHUP](https://sighup.io).
- :warning: : module version: `v1.7.0` and Kubernetes Version: `1.21.x`. It works as expected. Marked as warning
because it is not officially supported by [SIGHUP](https://sighup.io).

## License

For license details please see [LICENSE](./LICENSE)
