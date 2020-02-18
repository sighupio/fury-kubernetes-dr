terraform {
  backend "gcs" {}
}

provider "google" {
  version = "~> 3.6"
}

variable "gcp_project" {}
variable "my_cluster_name" {}
variable "environment" {
  default = "testing"
}

module "velero" {
  source             = "../../modules/gcp-velero"
  name               = var.my_cluster_name
  env                = var.environment
  backup_bucket_name = "${var.my_cluster_name}-${var.environment}-velero"
  project            = var.gcp_project
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
