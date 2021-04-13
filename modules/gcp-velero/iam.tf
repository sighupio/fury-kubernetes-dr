/**
 * Copyright (c) 2020 SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

resource "random_id" "velero" {
  byte_length = 2
}

resource "google_service_account" "velero" {
  project      = var.project
  account_id   = "velero-sa-${random_id.velero.hex}"
  display_name = "Velero account for ${var.backup_bucket_name}"
}

resource "google_service_account_key" "velero" {
  service_account_id = google_service_account.velero.name
}

# Custom role 
resource "google_project_iam_custom_role" "velero-role" {
  role_id     = "velero_role_${random_id.velero.hex}"
  title       = "Velero Role"
  description = "Custom role to assign to velero sa to allow it to create snapshots"
  permissions = [
    "compute.disks.get",
    "compute.disks.list",
    "compute.disks.create",
    "compute.disks.createSnapshot",
    "compute.snapshots.get",
    "compute.snapshots.list",
    "compute.snapshots.create",
    "compute.snapshots.useReadOnly",
    "compute.snapshots.delete",
    "compute.zones.get"
  ]
}

resource "google_project_iam_member" "project" {
  project = var.project
  role    = google_project_iam_custom_role.velero-role.id
  member  = "serviceAccount:${google_service_account.velero.email}"
}

