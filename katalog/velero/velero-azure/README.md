# Velero Azure

This Velero deployment is ready to be deployed in any Azure cluster as it includes the
[Azure Velero plugin](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure/tree/v1.11.0).

## Image repository and tag

- Velero Azure Plugin image: `velero/velero-plugin-for-microsoft-azure:v1.11.0`
- Velero Azure Plugin repository:
[https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure).


## Requirements

This deployment requires to have previously created the following resources:

- `cloud-credentials` Kubernetes Secret in the `kube-system` namespace.
- `default` BackupStorageLocation in the `kube-system` namespace.


### Cloud Credentials

This Fury Core module contains [a terraform module](../../../modules/azure-velero) designed to generate every file needed
by this deployment including the Cloud Credentials file.

```bash
$ terraform init
# omitted output
$ terraform apply
# omitted output
$ terraform output -raw cloud_credentials > /tmp/cloud_credentials.yaml
# omitted output
```

Then you are ready to apply this file in the `kube-system` namespace:

```bash
$ kubectl apply -f /tmp/cloud_credentials.yaml -n kube-system
secret/cloud-credentials created
```


### *Default* BackupStorageLocation

As this deployment creates a [`Schedule`](../velero-base/schedule.yaml) it's required to have a `BackupStorageLocation`
named `default` to automate the *manifests* backup creation.

Again, the terraform module provided with this deployment creates it as terraform output:

```bash
$ terraform init
$ terraform apply
$ terraform output -raw backup_storage_location > /tmp/backup_storage_location.yaml
$ cat /tmp/backup_storage_location.yaml
apiVersion: velero.io/v1
kind: BackupStorageLocation
metadata:
  name: default
spec:
  provider: velero.io/azure
  objectStorage:
    bucket: bucket-name-storing-kubernetes-manifests
  config:
    resourceGroup: 123-name
    storageAccount: 123-name
```

Then you are ready to apply this file in the `kube-system` namespace:

```bash
$ kubectl apply -f /tmp/backup_storage_location.yaml -n kube-system
# omitted output
```

## Deployment

You can deploy Velero Azure by running the following command in the root of this project:

```bash
$ kustomize build | kubectl apply -f -
# omitted output
```

## License

For license details please see [LICENSE](../../../LICENSE)
