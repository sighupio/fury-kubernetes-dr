/**
 * Copyright (c) 2020 SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

resource "google_service_account" "velero" {
  project      = var.project
  account_id   = "${var.name}-${var.env}-velero"
  display_name = "Velero account for ${var.name} at ${var.env}"
}

resource "google_service_account_key" "velero" {
  service_account_id = google_service_account.velero.name
}