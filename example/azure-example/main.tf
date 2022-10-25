/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

terraform {
  backend "azurerm" {}
  required_version = "0.15.4"
  required_providers {
    azurerm = "2.60.0"
    azuread = "1.5.0"
  }
}

provider "azurerm" {
  features {}
}

variable "my_cluster_name" {

}
variable "environment" {
  default = "testing"
}

module "velero" {
  source                     = "../../modules/azure-velero"
  backup_bucket_name         = "${var.my_cluster_name}${var.environment}"
  aks_resource_group_name    = "sighup-e2e-testing"
  velero_resource_group_name = "sighup-e2e-testing-velero"
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
