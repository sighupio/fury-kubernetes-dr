resource "azurerm_storage_account" "main" {
  name                      = "${var.name}${var.env}ark"
  resource_group_name       = "${data.azurerm_resource_group.main.name}"
  location                  = "${data.azurerm_resource_group.main.location}"
  account_kind              = "BlobStorage"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  access_tier               = "Hot"
  enable_blob_encryption    = true
  enable_https_traffic_only = true
  account_replication_type  = "GRS"

  tags {
    cluster     = "${var.name}"
    environment = "${var.env}"
  }
}

resource "azurerm_storage_container" "main" {
  name                  = "${var.name}-${var.env}-ark"
  resource_group_name   = "${data.azurerm_resource_group.main.name}"
  storage_account_name  = "${azurerm_storage_account.main.name}"
  container_access_type = "private"
}
