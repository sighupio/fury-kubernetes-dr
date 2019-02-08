locals {
  crd-velero = <<EOF
apiVersion: ark.heptio.com/v1
kind: BackupStorageLocation
metadata:
  name: default
spec:
  provider: gcp
  objectStorage:
    bucket: ${google_storage_bucket.main.name}
    prefix: ${var.bucket_prefix}
---
apiVersion: velero.io/v1
kind: VolumeSnapshotLocation
metadata:
  name: default
spec:
  provider: gcp
EOF
}

output "crd-velero" {
    value = "${local.crd-velero}"
}