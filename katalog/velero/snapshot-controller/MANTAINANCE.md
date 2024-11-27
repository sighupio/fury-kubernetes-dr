# Snapshot Controller Velero Package Maintenance Guide

To update the Snapshot Controller Velero package, follow the next steps:
- Get the upstream manifests using the following script:
```bash
#!/bin/bash

# Base URLs for CRDs and Snapshot Controller deployment
crd_base_url="https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/client/config/crd"
controller_base_url="https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/deploy/kubernetes/snapshot-controller"

# List of CRD manifests to download
crds=(
  "snapshot.storage.k8s.io_volumesnapshotclasses.yaml"
  "snapshot.storage.k8s.io_volumesnapshotcontents.yaml"
  "snapshot.storage.k8s.io_volumesnapshots.yaml"
  "groupsnapshot.storage.k8s.io_volumegroupsnapshotclasses.yaml"
  "groupsnapshot.storage.k8s.io_volumegroupsnapshotcontents.yaml"
  "groupsnapshot.storage.k8s.io_volumegroupsnapshots.yaml"
)

# List of Snapshot Controller RBAC and deployment to download
controllers=(
  "rbac-snapshot-controller.yaml"
  "setup-snapshot-controller.yaml"
)

# Combined CRDs manifest
combined_crds="combined_crds.yaml"

echo "Downloading CRD manifests..."
for crd in "${crds[@]}"; do
  curl -O "$crd_base_url/$crd" || { echo "Failed to download $crd"; exit 1; }

  cat "$crd" >> "$combined_crds"
  echo "---" >> "$combined_crds"
done

echo "Downloading Snapshot Controller RBAC and deployment manifests..."
for controller in "${controllers[@]}"; do
  curl -O "$controller_base_url/$controller" || { echo "Failed to download $controller"; exit 1; }
done
```

- Update CRDs in [`/katalog/velero/snapshot-controller/crds.yaml`](./crds.yaml)
- Update [`rbac.yaml`](rbac.yaml) and [`deployment.yaml`](./deployment.yaml) porting the needed changes
- Update the images tags
- Sync the image to our registry
