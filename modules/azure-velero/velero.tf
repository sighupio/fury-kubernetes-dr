/**
 * Copyright (c) 2020 SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

resource "azurerm_storage_account" "main" {
  name                     = "${var.name}${var.env}velero"
  resource_group_name      = data.azurerm_resource_group.velero.name
  location                 = data.azurerm_resource_group.velero.location
  account_kind             = "BlobStorage"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  access_tier              = "Hot"
  # https://github.com/terraform-providers/terraform-provider-azurerm/releases/tag/v2.0.0
  # Data Source: azurerm_storage_account - removing the enable_blob_encryption field since this is no longer configurable by Azure (#5668)
  # enable_blob_encryption    = true
  enable_https_traffic_only = true

  tags = {
    Name        = "${var.name}${var.env}velero"
    ClusterName = var.name
    Environment = var.env
  }
}

resource "azurerm_storage_container" "main" {
  name                  = var.backup_bucket_name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}
