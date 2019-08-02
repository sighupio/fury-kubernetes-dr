output "velero-credentials" {
  description = "velero environment variables with cloud credentials"
  value       = "${local.velero-credentials}"
}

locals {
  velero-credentials = <<EOF
AZURE_SUBSCRIPTION_ID=${data.azurerm_client_config.main.subscription_id}
AZURE_TENANT_ID=${data.azurerm_client_config.main.tenant_id}
AZURE_CLIENT_ID=${azuread_service_principal.main.application_id}
AZURE_CLIENT_SECRET=${azuread_service_principal_password.main.value}
AZURE_RESOURCE_GROUP=${data.azurerm_resource_group.kubernetes.name}
EOF
}

output "ark-storagelocation" {
  description = "Velero BackupStorageLocation CRD"
  value       = "${local.velero-storagelocation}"
}

locals {
  velero-storagelocation = <<EOF
apiVersion: velero.io/v1
kind: BackupStorageLocation
metadata:
  name: default
spec:
  provider: azure
  objectStorage:
    bucket: ${azurerm_storage_container.main.name}
  config:
    resourceGroup: ${data.azurerm_resource_group.velero.name}
    storageAccount: ${azurerm_storage_account.main.id}
EOF
}

output "velero-volumesnapshotlocation" {
  description = "Velero VolumeSnapshotLocation CRD"
  value       = "${local.velero-volumesnapshotlocation}"
}

locals {
  velero-volumesnapshotlocation = <<EOF
apiVersion: velero.io/v1
kind: VolumeSnapshotLocation
metadata:
  name: default
spec:
  provider: azure
  config:
    apiTimeout: 4m0s
    resouceGroup: ${data.azurerm_resource_group.kubernetes.name}
EOF
}
