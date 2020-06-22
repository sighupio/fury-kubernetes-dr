# Velero GCP

This Velero deployment is ready to be deployed in any GCP cluster as it includes the
[GCP Velero plugin](https://github.com/vmware-tanzu/velero-plugin-for-gcp/tree/v1.0.0).

## Image repository and tag

- Velero GCP Plugin image: `velero/velero-plugin-for-gcp:v1.0.0`
- Velero GCP Plugin repository:
[https://github.com/vmware-tanzu/velero-plugin-for-gcp](https://github.com/vmware-tanzu/velero-plugin-for-gcp).


## Requirements

This deployment requires to have previously created the following resources:

- `cloud-credentials` Kubernetes Secret in the `kube-system` namespace.
- `default` BackupStorageLocation in the `kube-system` namespace.


### Cloud Credentials

This Fury Core module contains [a terraform module](../../../modules/gcp-velero) designed to generate every file needed
by this deployment including the Cloud Credentials file.

```bash
$ terraform init
$ terraform apply
$ terraform output cloud_credentials > /tmp/cloud_credentials.json
$ cat /tmp/cloud_credentials.json
{
  "type": "service_account",
  "project_id": "sighup",
  "private_key_id": "",
  "private_key": "",
  "client_email": "drone",
  "client_id": "",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/drone-e2e%40sighup-main.iam.gserviceaccount.com"
}

```

Then you are ready to apply this file in the `kube-system` namespace:

```bash
$ kubectl create secret generic cloud-credentials --from-file=cloud=/tmp/cloud_credentials.json --dry-run -o yaml | kubectl apply -f - -n kube-system
# omitted output
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
  provider: velero.io/gcp
  objectStorage:
    bucket: bucket-name-storing-kubernetes-manifests
    prefix: velero
```

Then you are ready to apply this file in the `kube-system` namespace:

```bash
$ kubectl apply -f /tmp/backup_storage_location.yaml -n kube-system
# omitted output
```

## Deployment

You can deploy Velero GCP by running following command in the root of this project:

```bash
$ kustomize build | kubectl apply -f -
# omitted output
```

## License

For license details please see [LICENSE](../../../LICENSE)
