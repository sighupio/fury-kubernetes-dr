resource "random_string" "storage_account" {
  length  = 6
  special = false
  upper   = false

  keepers = {
    resource_group = "${data.azurerm_resource_group.velero.name}"
  }
}

resource "azurerm_storage_account" "main" {
  name                      = "${var.name}${var.env}${random_string.storage_account.result}"
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
    ClusterName = "${var.name}-${var.env}"
    Environment = "${var.env}"
  }
}

resource "azurerm_storage_container" "main" {
  name                  = "velero"
  resource_group_name   = "${data.azurerm_resource_group.velero.name}"
  storage_account_name  = "${azurerm_storage_account.main.name}"
  container_access_type = "private"
}
