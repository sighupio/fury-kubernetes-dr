terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  version = "2.10"
  features {}
}

variable "my_cluster_name" {

}
variable "environment" {
  default = "testing"
}

module "velero" {
  source                     = "../../modules/azure-velero"
  name                       = var.my_cluster_name
  env                        = var.environment
  backup_bucket_name         = "${var.my_cluster_name}-${var.environment}-velero"
  aks_resource_group_name    = "sighup-e2e-testing"
  velero_resource_group_name = "sighup-e2e-testing-velero"
}

output "cloud_credentials" {
  value     = module.velero.cloud_credentials
  sensitive = true
}

output "backup_storage_location" {
  value     = module.velero.backup_storage_location
  sensitive = true
}

output "volume_snapshot_location" {
  value     = module.velero.volume_snapshot_location
  sensitive = true
}
