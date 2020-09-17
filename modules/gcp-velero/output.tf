/**
 * Copyright (c) 2020 SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

locals {
  cloud_credentials = <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: cloud-credentials
  namespace: kube-system
type: Opaque
data:
  cloud: ${google_service_account_key.velero.private_key}
EOF

  backup_storage_location  = <<EOF
---
apiVersion: velero.io/v1
kind: BackupStorageLocation
metadata:
  name: default
  namespace: kube-system
spec:
  provider: velero.io/gcp
  objectStorage:
    bucket: ${google_storage_bucket.main.name}
    prefix: velero
EOF
  volume_snapshot_location = <<EOF
---
apiVersion: velero.io/v1
kind: VolumeSnapshotLocation
metadata:
  name: default
  namespace: kube-system
spec:
  provider: velero.io/gcp
EOF
}

output "cloud_credentials" {
  description = "Velero required file with credentials"
  value       = local.cloud_credentials
}

output "backup_storage_location" {
  description = "Velero Cloud BackupStorageLocation CRD"
  value       = local.backup_storage_location
}

output "volume_snapshot_location" {
  description = "Velero Cloud VolumeSnapshotLocation CRD"
  value       = local.volume_snapshot_location
}
