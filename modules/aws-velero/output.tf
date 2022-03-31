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
stringData:
  cloud: |-
    [default]
    aws_access_key_id=${element(coalescelist(aws_iam_access_key.velero_backup.*.id, [""]), 0)}
    aws_secret_access_key=${element(coalescelist(aws_iam_access_key.velero_backup.*.secret, [""]), 0)}
EOF

    service_account = <<EOF
---
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    eks.amazonaws.com/role-arn: ${element(coalescelist(aws_iam_role.velero_backup.*.arn, [""]), 0)}
  name: velero
  namespace: kube-system
EOF

  deployment = <<EOF
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: velero
  namespace: kube-system
spec:
  template:
    spec:
      containers:
      - name: velero
        volumeMounts:
        - name: cloud-credentials
          mountPath: /credentials
          $patch: delete
      volumes:
      - name: cloud-credentials
        $patch: delete
EOF

  backup_storage_location = <<EOF
---
apiVersion: velero.io/v1
kind: BackupStorageLocation
metadata:
  name: default
  namespace: kube-system
spec:
  provider: velero.io/aws
  objectStorage:
    bucket: ${aws_s3_bucket.backup_bucket.bucket}
  config:
    region: ${aws_s3_bucket.backup_bucket.region}
EOF

  volume_snapshot_location = <<EOF
---
apiVersion: velero.io/v1
kind: VolumeSnapshotLocation
metadata:
  name: default
  namespace: kube-system
spec:
  provider: velero.io/aws
  config:
    region: ${aws_s3_bucket.backup_bucket.region}
EOF
}

output "cloud_credentials" {
  description = "Velero required file with credentials"
  value       = local.cloud_credentials
}

output "deployment" {
  description = "Velero Deployment Kustomize patch"
  value = local.deployment
}

output "backup_storage_location" {
  description = "Velero Cloud BackupStorageLocation CRD"
  value       = local.backup_storage_location
}

output "volume_snapshot_location" {
  description = "Velero Cloud VolumeSnapshotLocation CRD"
  value       = local.volume_snapshot_location
}

output "service_account" {
  description = "Velero ServiceAccount"
  value = local.service_account
}
