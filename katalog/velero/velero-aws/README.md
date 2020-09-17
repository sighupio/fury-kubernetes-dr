# Velero AWS

This Velero deployment is ready to be deployed in any AWS cluster as it includes the
[AWS Velero plugin](https://github.com/vmware-tanzu/velero-plugin-for-aws/tree/v1.1.0).

## Image repository and tag

- Velero AWS Plugin image: `velero/velero-plugin-for-aws:v1.1.0`
- Velero AWS Plugin repository:
[https://github.com/vmware-tanzu/velero-plugin-for-aws](https://github.com/vmware-tanzu/velero-plugin-for-aws).


## Requirements

This deployment requires to have previously created the following resources:

- `cloud-credentials` Kubernetes Secret in the `kube-system` namespace.
- `default` BackupStorageLocation in the `kube-system` namespace.


### Cloud Credentials

This Fury Core module contains [a terraform module](../../../modules/aws-velero) designed to generate every file needed
by this deployment including the Cloud Credentials file.

```bash
$ terraform init
# omitted output
$ terraform apply
# omitted output
$ terraform output cloud_credentials > /tmp/cloud_credentials.yaml
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
$ terraform output backup_storage_location > /tmp/backup_storage_location.yaml
$ cat /tmp/backup_storage_location.yaml
apiVersion: velero.io/v1
kind: BackupStorageLocation
metadata:
  name: default
spec:
  provider: velero.io/aws
  objectStorage:
    bucket: bucket-name-storing-kubernetes-manifests
  config:
    region: aws-region-10
```

Then you are ready to apply this file in the `kube-system` namespace:

```bash
$ kubectl apply -f /tmp/backup_storage_location.yaml -n kube-system
# omitted output
```

## Deployment

You can deploy Velero AWS by running the following command in the root of this project:

```bash
$ kustomize build | kubectl apply -f -
# omitted output
```

## License

For license details please see [LICENSE](../../../LICENSE)
