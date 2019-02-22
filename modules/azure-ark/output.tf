output "ark-credentials" {
  value = "${local.ark-credentials}"
}

locals {
  ark-credentials = <<EOF
AZURE_SUBSCRIPTION_ID=${data.azurerm_subscription.main.subscription_id}
AZURE_TENANT_ID=${var.tenant_id}
AZURE_CLIENT_ID=${azuread_service_principal.main.application_id}
AZURE_CLIENT_SECRET=${azuread_service_principal_password.main.value}
AZURE_RESOURCE_GROUP=${data.azurerm_resource_group.aks.name}
EOF
}

output "ark-storagelocation" {
  value = "${local.ark-storagelocation}"
}

locals {
  ark-storagelocation = <<EOF
apiVersion: ark.heptio.com/v1
kind: BackupStorageLocation
metadata:
  name: default
spec:
  provider: azure
  objectStorage:
    bucket: ${azurerm_storage_container.main.name}
  config:
    resourceGroup: ${data.azurerm_resource_group.main.name}
    storageAccount: ${azurerm_storage_account.main.name}
EOF
}

output "ark-volumesnapshotlocation" {
  value = "${local.ark-volumesnapshotlocation}"
}

locals {
  ark-volumesnapshotlocation = <<EOF
apiVersion: ark.heptio.com/v1
kind: VolumeSnapshotLocation
metadata:
  name: default
spec:
  provider: azure
  config:
    apiTimeout: 4m0s
    resouceGroup: ${data.azurerm_resource_group.main.name}
EOF
}
