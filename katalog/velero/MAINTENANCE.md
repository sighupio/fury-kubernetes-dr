# Velero Package Maintenance Guide

To update the Velero package, follow the next steps:
- Update the Velero CLI to your target version
- Get the upstream manifest with
```bash
velero install --namespace kube-system --provider aws --no-secret --bucket my-bucket --dry-run -o yaml --plugins velero/velero-plugin-for-aws:<tag> --use-node-agent > orig.yaml
```
- Update CRDs in [`/katalog/velero/velero-base/crds.yaml`](./velero-base/crds.yaml) with: `velero install --crds-only --dry-run -o yaml > crds.yaml`
- Port the needed changes
- Update the images tags
- Sync the image to our registry

## Customizations
- The package has been split in three Kustomize bases:
  - [`velero-base`](./velero-base)
  - [`velero-restic`](./velero-restic)
  - [`velero-schedules`](./velero-schedules)

  and four Kustomize overlays:
  - [`velero-aws`](./velero-aws)
  - [`velero-azure`](./velero-azure)
  - [`velero-gcp`](./velero-gcp)
  - [`velero-on-prem`](./velero-on-prem)
- Split the manifests into different files
- Velero is deployed in the `kube-system` namespace instead of `velero`
- Added `securityContext` to Velero `Deployment`
- Removed Prometheus annotations from Velero `Deployment`
- Added a `Service` and a `ServiceMonitor` for monitoring
