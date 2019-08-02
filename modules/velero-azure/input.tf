variable "name" {
  description = "name of the project"
  type        = "string"
}

variable "env" {
  description = "name of the environment"
  type        = "string"
}

variable "kubernetes_resource_group_name" {
  description = "kubernetes cluster resource group name"
  type        = "string"
}

variable "velero_resource_group_name" {
  description = "velero resource group name"
  type        = "string"
}

data "azurerm_client_config" "main" {}

data "azurerm_resource_group" "velero" {
  name = "${var.velero_resource_group_name}"
}

data "azurerm_resource_group" "kubernetes" {
  name = "${var.kubernetes_resource_group_name}"
}
