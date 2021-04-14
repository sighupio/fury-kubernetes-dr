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

  backup_storage_location = <<EOF
---
apiVersion: velero.io/v1
kind: BackupStorageLocation
metadata:
  name: default
  namespace: kube-system
spec:
  provider: velero.io/gcp
  objectStorage:
    bucket: ${google_storage_bucket.velero.name}
    prefix: velero
  config:
    serviceAccount: ${google_service_account.velero.email}
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

  kubernetes_service_account_patch = <<EOF
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: velero
  annotations:
    iam.gke.io/gcp-service-account: ${google_service_account.velero.email}
EOF
}

output "cloud_credentials" {
  description = "Velero required file with credentials in case no workload identity is used"
  value       = var.workload_identity ? null : local.cloud_credentials
  sensitive   = true
}

output "backup_storage_location" {
  description = "Velero Cloud BackupStorageLocation CRD"
  value       = local.backup_storage_location
  sensitive   = true
}

output "volume_snapshot_location" {
  description = "Velero Cloud VolumeSnapshotLocation CRD"
  value       = local.volume_snapshot_location
  sensitive   = true
}

output "kubernetes_service_account_patch" {
  description = "Patch for the Kubernetes service account to use workload identity"
  value       = var.workload_identity ? local.kubernetes_service_account_patch : null
  sensitive   = true
}
