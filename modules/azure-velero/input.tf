variable "name" {
  type        = string
  description = "Cluster Name"
}
variable "env" {
  type        = string
  description = "Environment Name"
}
variable "backup_bucket_name" {
  type        = string
  description = "Backup Bucket Name"
}

variable "azure_cloud_name" {
  type        = string
  description = "available azure_cloud_name values: AzurePublicCloud, AzureUSGovernmentCloud, AzureChinaCloud, AzureGermanCloud"
  default     = "AzurePublicCloud"
}

variable "aks_resource_group_name" {
  type        = string
  description = "Resource group name of AKS cluster to backup"
}

variable "velero_resource_group_name" {
  type        = string
  description = "Resouce group in which to create velero resources"
}

data "azurerm_client_config" "main" {}

data "azurerm_resource_group" "velero" {
  name = "${var.velero_resource_group_name}"
}

data "azurerm_resource_group" "aks" {
  name = "${var.aks_resource_group_name}"
}
