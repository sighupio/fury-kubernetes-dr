resource "aws_iam_user" "ark-backup" {
  name = "${var.cluster_name}-${var.environment}-ark-backup"
  path = "/"
}

resource "aws_iam_policy_attachment" "ark-backup" {
  name       = "${var.cluster_name}-${var.environment}-ark-backup"
  users      = ["${aws_iam_user.ark-backup.name}"]
  policy_arn = "${aws_iam_policy.ark-backup.arn}"
}

resource "aws_iam_access_key" "ark-backup" {
  user = "${aws_iam_user.ark-backup.name}"
}

resource "aws_iam_policy" "ark-backup" {
  name = "${var.cluster_name}-${var.environment}-ark-backup"

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
            "Resource": "${aws_s3_bucket.ark-backup.arn}/*"
         },
         {
             "Effect": "Allow",
             "Action": [
                 "s3:ListBucket"
             ],
            "Resource": "${aws_s3_bucket.ark-backup.arn}"
         }
     ]
}
EOF
}
