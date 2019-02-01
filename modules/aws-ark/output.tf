locals {
  ark-credentials = <<EOF
[default]
aws_access_key_id=${aws_iam_access_key.ark-backup.id}
aws_secret_access_key=${aws_iam_access_key.ark-backup.secret}
EOF
}

output "ark-credentials" {
  value = "${local.ark-credentials}"
}

output "bucket_username" {
  value = "${aws_iam_user.ark-backup.name}"
}

output "bucket_policy" {
  value = "${aws_iam_policy.ark-backup.arn}"
}
