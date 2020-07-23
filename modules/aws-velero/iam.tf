resource "aws_iam_user" "velero_backup_user" {
  count = length(var.oidc_provider_url) != 0 ? 0 : 1
  name = "${var.name}-${var.env}-velero-backup"
  path = "/"
}

resource "aws_iam_policy_attachment" "velero_backup" {
  count = length(var.oidc_provider_url) != 0 ? 0 : 1
  name       = "${var.name}-${var.env}-velero-backup"
  users      = [aws_iam_user.velero_backup_user.0.name]
  policy_arn = aws_iam_policy.velero_backup.arn
}

resource "aws_iam_access_key" "velero_backup" {
  count = length(var.oidc_provider_url) != 0 ? 0 : 1
  user = aws_iam_user.velero_backup_user.0.name
}

resource "aws_iam_policy" "velero_backup" {
  name = "${var.name}-${var.env}-velero-backup"

  policy = <<EOF
{
     "Version": "2012-10-17",
     "Statement": [
         {
             "Effect": "Allow",
             "Action": [
                 "ec2:DescribeVolumes",
                 "ec2:DescribeSnapshots",
                 "ec2:CreateTags",
                 "ec2:CreateVolume",
                 "ec2:CreateSnapshot",
                 "ec2:DeleteSnapshot"
             ],
             "Resource": "*"
         },
         {
             "Effect": "Allow",
             "Action": [
                 "s3:GetObject",
                 "s3:DeleteObject",
                 "s3:PutObject",
                 "s3:AbortMultipartUpload",
                 "s3:ListMultipartUploadParts"
             ],
            "Resource": "${aws_s3_bucket.backup_bucket.arn}/*"
         },
         {
             "Effect": "Allow",
             "Action": [
                 "s3:ListBucket"
             ],
            "Resource": "${aws_s3_bucket.backup_bucket.arn}"
         }
     ]
}
EOF
}

resource "aws_iam_role" "velero_backup" {
  count = length(var.oidc_provider_url) != 0 ? 1 : 0
  name = "${var.name}-${var.env}-velero-backup"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.oidc_provider_url}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "${var.oidc_provider_url}:sub": "system:serviceaccount:kube-system:velero"
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "velero_backup" {
  count = length(var.oidc_provider_url) != 0 ? 1 : 0
  role = aws_iam_role.velero_backup.0.name
  policy_arn = aws_iam_policy.velero_backup.arn
}
