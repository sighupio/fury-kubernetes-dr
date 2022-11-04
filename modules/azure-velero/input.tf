/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

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

variable "tags" {
  type        = map(string)
  description = "Custom tags to apply to resources"
  default     = {}
}

data "azurerm_client_config" "main" {}

data "azurerm_resource_group" "velero" {
  name = var.velero_resource_group_name
}

data "azurerm_resource_group" "aks" {
  name = var.aks_resource_group_name
}
