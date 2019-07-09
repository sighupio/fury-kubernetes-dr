variable name {
  type        = "string"
  description = "Cluster name"
}

variable env {
  type        = "string"
  description = "Cluster environment"
}

variable aks_resource_group_name {
  type        = "string"
  description = "Resource group name of AKS cluster to backup"
}

variable ark_resource_group_name {
  type        = "string"
  description = "Resouce group in which to create Ark resources"
}

provider "azurerm" {}

data "azurerm_client_config" "main" {}

data "azurerm_resource_group" "main" {
  name = "${var.ark_resource_group_name}"
}

data "azurerm_resource_group" "aks" {
  name = "${var.aks_resource_group_name}"
}
