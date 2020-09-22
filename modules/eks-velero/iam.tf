/**
 * Copyright (c) 2020 SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

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
  role = aws_iam_role.velero_backup.name
  policy_arn = aws_iam_policy.velero_backup.arn
}
