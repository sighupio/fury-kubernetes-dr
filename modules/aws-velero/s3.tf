resource "aws_s3_bucket" "backup_bucket" {
  bucket        = "${var.backup_bucket_name}"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags {
    Name        = "${var.backup_bucket_name}"
    ClusterName = "${var.cluster_name}"
    Environment = "${var.environment}"
  }
}
