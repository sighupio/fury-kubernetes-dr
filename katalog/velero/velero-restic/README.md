# Velero Restic

Velero has support for backing up and restoring Kubernetes volumes using a free open-source backup tool called
[restic](https://github.com/restic/restic). This support is considered beta quality. Please see the list of
[limitations](https://velero.io/docs/master/restic/#limitations) to understand if it currently fits your use
case.

## Image repository and tag

- Velero Restic image: `velero/velero:v1.5.1`
- Velero Restic repository: [https://github.com/vmware-tanzu/velero](https://github.com/vmware-tanzu/velero).


## Requirements

This deployment requires to have previously deployed a velero instance. Choose one option:

- [velero on premises](../velero-on-prem)
- [velero AWS](../velero-aws)
- [velero GCP](../velero-gcp)
- [velero Azure](../velero-azure)


## Deployment

You can deploy Velero AWS by running the following command in the root of this project:

```bash
$ kustomize build | kubectl apply -f -
# omitted output
```

## License

For license details please see [LICENSE](../../../LICENSE)
