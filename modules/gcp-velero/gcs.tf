/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

# Create a unique GCS bucket per cluster
resource "google_storage_bucket" "main" {
  name                        = var.backup_bucket_name
  uniform_bucket_level_access = true
  project                     = var.project
  location                    = "EU"
  force_destroy               = true
  lifecycle {
    prevent_destroy = false
  }

  labels = var.tags
}

resource "null_resource" "verify_service_account" {
  depends_on = [google_service_account.velero]
  
  provisioner "local-exec" {
    command = <<EOT
      until gcloud iam service-accounts describe ${google_service_account.velero.email} --format="value(email)" 2>/dev/null; do
        echo "Waiting for service account to be fully created..."
        sleep 5
      done
    EOT
  }
}

resource "google_storage_bucket_iam_binding" "velero_bucket_iam" {
  bucket = google_storage_bucket.main.name
  role   = "roles/storage.objectAdmin"

  members = [
    "serviceAccount:${google_service_account.velero.email}"
  ]

  depends_on = [null_resource.verify_service_account]

  lifecycle {
    prevent_destroy = false
  }
}
