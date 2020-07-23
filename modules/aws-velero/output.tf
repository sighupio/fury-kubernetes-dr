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
    aws_access_key_id=${aws_iam_access_key.velero_backup.id}
    aws_secret_access_key=${aws_iam_access_key.velero_backup.secret}
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

  backup_storage_location  = <<EOF
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
    region: ${var.region}
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
    region: ${var.region}
EOF
}

output "cloud_credentials" {
  description = "Velero required file with credentials"
  value       = local.cloud_credentials
}

output "service_account" {
  description = "Velero ServiceAccount"
  value = local.service_account
}

output "backup_storage_location" {
  description = "Velero Cloud BackupStorageLocation CRD"
  value       = local.backup_storage_location
}

output "volume_snapshot_location" {
  description = "Velero Cloud VolumeSnapshotLocation CRD"
  value       = local.volume_snapshot_location
}
