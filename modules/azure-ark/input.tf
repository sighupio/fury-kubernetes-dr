variable cluster_name {}
variable env {}
variable region {}
variable tenant_id {}
variable ark_backup_bucket_name {}

provider "azurerm" {}

data "azurerm_subscription" "main" {}

data "azurerm_resource_group" "main" {
  name = "${var.cluster_name}-${var.env}"
}

data "azurerm_resource_group" "aks" {
  name = "${data.azurerm_kubernetes_cluster.main.node_resource_group}"
}

data "azurerm_kubernetes_cluster" "main" {
  name                = "${var.cluster_name}-${var.env}"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
}
