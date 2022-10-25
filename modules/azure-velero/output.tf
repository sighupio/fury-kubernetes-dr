/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

locals {
  cloud_credentials = <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: cloud-credentials
  namespace: kube-system
type: Opaque
stringData:
  cloud: |-
    AZURE_SUBSCRIPTION_ID=${data.azurerm_client_config.main.subscription_id}
    AZURE_TENANT_ID=${data.azurerm_client_config.main.tenant_id}
    AZURE_CLIENT_ID=${azuread_service_principal.main.application_id}
    AZURE_CLIENT_SECRET=${azuread_service_principal_password.main.value}
    AZURE_RESOURCE_GROUP=${data.azurerm_resource_group.aks.name}
    AZURE_CLOUD_NAME=${var.azure_cloud_name}
EOF

  backup_storage_location = <<EOF
---
apiVersion: velero.io/v1
kind: BackupStorageLocation
metadata:
  name: default
  namespace: kube-system
spec:
  provider: velero.io/azure
  objectStorage:
    bucket: ${azurerm_storage_container.main.name}
  config:
    resourceGroup: ${data.azurerm_resource_group.velero.name}
    storageAccount: ${azurerm_storage_account.main.name}
EOF

  volume_snapshot_location = <<EOF
---
apiVersion: velero.io/v1
kind: VolumeSnapshotLocation
metadata:
  name: default
  namespace: kube-system
spec:
  provider: velero.io/azure
  config:
    apiTimeout: 4m0s
    resourceGroup: ${data.azurerm_resource_group.velero.name}
EOF
}

output "cloud_credentials" {
  description = "Velero required file with credentials"
  value       = local.cloud_credentials
}

output "backup_storage_location" {
  description = "Velero Cloud BackupStorageLocation CRD"
  value       = local.backup_storage_location
}

output "volume_snapshot_location" {
  description = "Velero Cloud VolumeSnapshotLocation CRD"
  value       = local.volume_snapshot_location
}
