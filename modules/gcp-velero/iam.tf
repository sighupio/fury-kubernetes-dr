/**
 * Copyright (c) 2020 SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

resource "google_service_account" "velero" {
  project      = var.project
  account_id   = "${var.backup_bucket_name}-velero"
  display_name = "Velero account for ${var.backup_bucket_name}"
}

resource "google_service_account_key" "velero" {
  service_account_id = google_service_account.velero.name
}
