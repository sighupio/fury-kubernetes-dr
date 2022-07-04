/**
 * Copyright (c) 2022 SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

locals {
  cloud_credentials = <<EOF
---
apiVersion: v1
stringData:
  cloud: |-
    [default]
    aws_access_key_id=${oci_identity_customer_secret_key.velero.id}
    aws_secret_access_key=${oci_identity_customer_secret_key.velero.key}
kind: Secret
metadata:
  name: cloud-credentials
  namespace: kube-system
type: Opaque
EOF

  backup_storage_location = <<EOF
---
apiVersion: velero.io/v1
kind: BackupStorageLocation
metadata:
  name: default
  namespace: kube-system
spec:
  provider: aws
  objectStorage:
    bucket: ${var.backup_bucket_name}
  config:
    region: ${var.region}
    s3ForcePathStyle: "true"
    s3Url: https://${var.object-storage-namespace}.compat.objectstorage.${var.region}.oraclecloud.com
EOF

  volume_snapshot_location = <<EOF
---
apiVersion: velero.io/v1
kind: VolumeSnapshotLocation
metadata:
  name: default
  namespace: kube-system
spec:
  provider: aws
  config:
    region: ${var.region}
EOF

}


output "cloud_credentials" {
  description = "Velero OKE credentials"
  sensitive   = true
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
