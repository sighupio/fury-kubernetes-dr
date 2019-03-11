locals {
  ark-credentials = <<EOF
[default]
aws_access_key_id=${aws_iam_access_key.ark-backup.id}
aws_secret_access_key=${aws_iam_access_key.ark-backup.secret}
EOF

  ark-crds = <<EOF
apiVersion: ark.heptio.com/v1
kind: BackupStorageLocation
metadata:
  name: default
spec:
  provider: aws
  objectStorage:
    bucket: ${aws_s3_bucket.ark-backup.bucket}
  config:
    region: ${var.aws_region}
---
apiVersion: ark.heptio.com/v1
kind: VolumeSnapshotLocation
metadata:
  name: default
spec:
  provider: aws
  config:
    region: ${var.aws_region}
EOF
}

output "ark-credentials" {
  value = "${local.ark-credentials}"
}

output "ark-crds" {
  value = "${local.ark-crds}"
}

output "bucket_username" {
  value = "${aws_iam_user.ark-backup.name}"
}

output "bucket_policy" {
  value = "${aws_iam_policy.ark-backup.arn}"
}
