# Velero on Premises

This Velero deployment is ready to be deployed in any Kubernetes cluster as it includes a MinIO instance compatible with
the [AWS Velero plugin](https://github.com/vmware-tanzu/velero-plugin-for-aws/tree/v1.11.1).

## Image repository and tag

- Velero AWS Plugin image: `velero/velero-plugin-for-aws:v1.11.1`
- Velero AWS Plugin repository:
[https://github.com/vmware-tanzu/velero-plugin-for-aws](https://github.com/vmware-tanzu/velero-plugin-for-aws).
- MinIO image: `minio/minio:RELEASE.2025-02-28T09-55-16Z`
- MinIO client image: `minio/mc:RELEASE.2025-02-21T16-00-46Z`
- MinIO repository: [https://github.com/minio/minio](https://github.com/minio/minio)


## Deployment

You can deploy Velero AWS by running the following command in the root of this project:

```bash
$ kustomize build | kubectl apply -f -
# omitted output
```

### Important Notes

The deployment order is managed by an `initContainer` that waits for a set of conditions. In this case, velero deployment
waits for MinIO instance to be fully configured and ready.

You can see it in [plugin-patch.yaml](./plugin-patch.yaml) and [minio/init-job.yaml](minio/init-job.yaml).

## License

For license details please see [LICENSE](../../../LICENSE)
