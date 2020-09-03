# Releases notes

## Changelog

Changes between `1.4.0` and this release: `TBD`.

- Change cloud credentials terraform output to be a Kubernetes manifests instead of a plain text file.
  - Applies to the three different providers *(aws, azure and gcp)*.

## Changes

### Cloud Credentials

Before TBD version, you run commands like:

```bash
$ terraform output cloud_credentials > /shared/cloud_credentials.config
$ kubectl create secret generic cloud-credentials --from-file=cloud=/shared/cloud_credentials.config --dry-run -o yaml | kubectl apply -f - -n kube-system
secret/cloud-credentials created
```

Now, to apply the cloud credentials to the cluster:

```bash
$ terraform output cloud_credentials > /shared/cloud_credentials.yaml
$ kubectl apply -f /shared/cloud_credentials.yaml
secret/cloud-credentials created
```
