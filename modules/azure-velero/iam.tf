/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

resource "azuread_application" "main" {
  display_name = "${var.backup_bucket_name}-velero"
}

resource "azuread_service_principal" "main" {
  application_id               = azuread_application.main.application_id
  app_role_assignment_required = true
}

resource "azuread_service_principal_password" "main" {
  service_principal_id = azuread_service_principal.main.id
  end_date             = timeadd(timestamp(), "8760h")

  # This stops be 'end_date' changing on each run and causing a new password to be set
  # to get the date to change here you would have to manually taint this resource...
  lifecycle {
    ignore_changes = [end_date]
  }
}

resource "azurerm_role_definition" "velero" {
  name  = "${var.backup_bucket_name}-velero"
  scope = data.azurerm_resource_group.velero.id
  permissions {
    actions = [
      "Microsoft.Compute/disks/read",
      "Microsoft.Compute/disks/write",
      "Microsoft.Compute/disks/endGetAccess/action",
      "Microsoft.Compute/disks/beginGetAccess/action",
      "Microsoft.Compute/snapshots/read",
      "Microsoft.Compute/snapshots/write",
      "Microsoft.Compute/snapshots/delete",
      "Microsoft.Storage/storageAccounts/listkeys/action",
      "Microsoft.Storage/storageAccounts/regeneratekey/action",
      "Microsoft.Storage/storageAccounts/blobServices/containers/delete",
      "Microsoft.Storage/storageAccounts/blobServices/containers/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/write",
      "Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action",
    ]
    data_actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/move/action",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action"
    ]
  }
  assignable_scopes = [
    data.azurerm_resource_group.aks.id,
    data.azurerm_resource_group.velero.id
  ]
}

resource "azurerm_role_assignment" "aks" {
  scope                            = data.azurerm_resource_group.aks.id
  role_definition_id               = azurerm_role_definition.velero.role_definition_resource_id
  principal_id                     = azuread_service_principal.main.id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "snapshot" {
  scope                            = data.azurerm_resource_group.velero.id
  role_definition_id               = azurerm_role_definition.velero.role_definition_resource_id
  principal_id                     = azuread_service_principal.main.id
  skip_service_principal_aad_check = true
}

