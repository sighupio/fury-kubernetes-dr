resource "azurerm_storage_account" "main" {
  name                      = "${var.name}${var.env}velero"
  resource_group_name       = "${data.azurerm_resource_group.velero.name}"
  location                  = "${data.azurerm_resource_group.velero.location}"
  account_kind              = "BlobStorage"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  access_tier               = "Hot"
  enable_blob_encryption    = true
  enable_https_traffic_only = true
  account_replication_type  = "GRS"

  tags {
    Name        = "${var.name}${var.env}velero"
    ClusterName = "${var.cluster_name}"
    Environment = "${var.environment}"
  }
}

resource "azurerm_storage_container" "main" {
  name                  = "${var.backup_bucket_name}"
  resource_group_name   = "${data.azurerm_resource_group.velero.name}"
  storage_account_name  = "${azurerm_storage_account.main.name}"
  container_access_type = "private"
}
