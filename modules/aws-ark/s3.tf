resource "aws_s3_bucket" "ark-backup" {
  bucket = "${var.ark_backup_bucket_name}"
  acl    = "private"

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
    Name        = "${var.ark_backup_bucket_name}"
    Environment = "Production"
  }
}
