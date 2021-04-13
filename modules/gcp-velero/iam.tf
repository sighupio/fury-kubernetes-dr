/**
 * Copyright (c) 2020 SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

locals {
  velero_role_permissions = [
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

resource "google_service_account" "velero" {
  project      = var.project
  account_id   = var.google_service_account_name
  display_name = "Service account for Velero"
}

resource "google_service_account_key" "velero" {
  service_account_id = google_service_account.velero.name
}

resource "google_project_iam_custom_role" "velero-role" {
  role_id     = "${replace(var.google_service_account_name, "-", "_")}_role"
  title       = "Velero Role"
  description = "Custom role to assign to velero sa to allow it to create snapshots"
  permissions = var.workload_identity ? concat(local.velero_role_permissions, ["iam.serviceAccounts.signBlob"]) : local.velero_role_permissions
}

resource "google_project_iam_member" "project" {
  project = var.project
  role    = google_project_iam_custom_role.velero-role.id
  member  = "serviceAccount:${google_service_account.velero.email}"
}

# Workload identity
resource "google_service_account_iam_binding" "roles" {
  count = var.workload_identity ? 1 : 0
  members = [
    "serviceAccount:niccolo-raspa-test-project.svc.id.goog[kube-system/${var.workload_identity_kubernetes_service_account}]",
  ]
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.velero.id
}
