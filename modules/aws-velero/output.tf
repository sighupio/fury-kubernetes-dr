locals {
  cloud_credentials = <<EOF
[default]
aws_access_key_id=${aws_iam_access_key.velero_backup.id}
aws_secret_access_key=${aws_iam_access_key.velero_backup.secret}
EOF

  backup_storage_location  = <<EOF
apiVersion: velero.io/v1
kind: BackupStorageLocation
metadata:
  name: default
spec:
  provider: velero.io/aws
  objectStorage:
    bucket: ${aws_s3_bucket.backup_bucket.bucket}
  config:
    region: ${var.aws_region}
EOF
  volume_snapshot_location = <<EOF
apiVersion: velero.io/v1
kind: VolumeSnapshotLocation
metadata:
  name: default
spec:
  provider: velero.io/aws
  config:
    region: ${var.aws_region}
EOF
}

output "cloud_credentials" {
  value = "${local.cloud_credentials}"
}

output "backup_storage_location" {
  value = "${local.backup_storage_location}"
}

output "volume_snapshot_location" {
  value = "${local.volume_snapshot_location}"
}
