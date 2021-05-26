/**
 * Copyright (c) 2020 SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

terraform {
  backend "gcs" {}
  required_version = "0.15.4"
  required_providers {
    google = "3.55.0"
  }
}

variable "gcp_project" {}
variable "my_cluster_name" {}
variable "environment" {
  default = "testing"
}

module "velero" {
  source                   = "../../modules/gcp-velero"
  backup_bucket_name       = "${var.my_cluster_name}-${var.environment}-velero"
  gcp_service_account_name = "${var.my_cluster_name}-${var.environment}-velero"
  project                  = var.gcp_project
}

output "cloud_credentials" {
  value     = module.velero.cloud_credentials
  sensitive = true
}

output "backup_storage_location" {
  value     = module.velero.backup_storage_location
  sensitive = true
}

output "volume_snapshot_location" {
  value     = module.velero.volume_snapshot_location
  sensitive = true
}
